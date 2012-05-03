module Paperclip
  class Normalize < Processor
    attr_accessor :format

    # Creates an object set to work on the file given. It will attempt to normalize
    # any audio contained in the file (audio content or audio track in the case of
    # a video container)
    def initialize file, options = {}, attachment = nil
      @file            = file
      @whiny           = options[:whiny].nil? ? true : options[:whiny]
      @format          = options[:format]
      @current_format  = File.extname(@file.path)
      @basename        = File.basename(@file.path, @current_format)
    end
    
    # Performs the normalization of the file into an audio/video file.
    # TODO: detect mimetype of source file instead of using file extension
    #
    # Returns the original file after the process has been run
    def make
      case @current_format
      # Handle audio files
      when 'wav', 'mp3', 'aac'
        return process_audio_file
      
      # Handle video files
      when 'mp4' #Video files
        return process_video_file
        
      # unprocessable filetype  
      else
        Paperclip.log "[normalize] error while processing audio for #{@basename}: not a video or audio file"
      end
    end
    
    protected
    
    # Normalizes an audio file
    #
    # Returns a processed file
    def process_audio_file
      src = @file
      dst = Tempfile.new([@basename, ".wav"])
      dst.binmode
      
      # Copy source file to destination file
      FileUtils.copy_stream(src, dst)
      dst.flush
      
      parameters = ":source"
    
      begin
        Paperclip.log("[normalize] #{parameters}")
        Paperclip.run("normalize-audio", parameters, :source => "#{File.expand_path(src.path)}")
      rescue Cocaine::ExitStatusError => e
        raise PaperclipError, "error while processing audio for #{@basename}: #{e}" if @whiny
      end
      
      dst
    end
    
    # Normalizes the audio track of a video file
    #
    # Returns a processed file
    def process_video_file
      src = @file
      dst = Tempfile.new([@basename, ".wav"])
      dst.binmode
        
      tmp_wav_file = Tempfile.new([@basename, ".wav"])
      tmp_wav_file.binmode
        
      begin
        # Copy the audio track from the video to a temporary wav file
        parameters = "-i :source -acodec pcm_s16le :audio"
        Paperclip.log("[normalize ffmpeg] #{parameters}")
        Paperclip.run('ffmpeg', parameters, :source => File.expand_path(src.path), :audio => File.expand_path(tmp_wav_file.path))
        
        # Run normalization on the wav file
        parameters = ":audio"
        Paperclip.log("[normalize] #{parameters}")
        Paperclip.run('normalize-audio', parameters, :audio => File.expand_path(tmp_wav_file.path)
        
        # Copy the audio track back into the video file
        parameters = "-i :source -i :audio -map 0:0 -map 1:0 -vcodec copy -acodec copy :dest"
        Paperclip.log("[normalize ffmpeg] #{parameters}")
        Paperclip.run('ffmpeg', parameters, :source => File.expand_path(src.path), :audio => File.expand_path(tmp_wav_file.path), :dest => File.expand_path(dst.path))
      rescue Cocaine::ExitStatusError => e
        raise PaperclipError, "error while processing audio for #{@basename}: #{e}" if @whiny
      ensure
        # Make sure to clean up the wav file
        tmp_wav_file.close
        tmp_wav_file.unlink
      end
      
      dst
    end
  end
end