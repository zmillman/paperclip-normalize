# Paperclip Normalize #

THIS GEM IS NOT IMPLEMENTED. DO NOT USE IT YET!

Add an audio normalization processor to Paperclip using normalize-audio for processing audio and video files.

This gem has been developed for use with Ubuntu. Your mileage may vary on other systems.

## What is Audio Normalization? ##

Audio normalization is the process of adjusting the volume of a track to bring the loudness to a target level.

## Installation ##

Add to your Gemfile:

  ```ruby
  gem "paperclip-normalize", :git => "git://github.com/zmillman/paperclip-normalize.git"
  ```
normalize-audio must also be installed and Paperclip must have access to it.

    > sudo apt-get install normalize-audio

## Usage ##

In your model:

  ```ruby
  class Podcast < ActiveRecord::Base
    has_attached_file :audio, :styles => {
        :release => {:format => 'mp3' }
      }, :processors => [:normalize]
  end
  ```

This will produce a transcoded `:release` mp3 file with the audio normalized to 0dB.

## Normalizing Video ##

paperclip-normalize can also normalize the audio tracks in video files. To do this, you must have FFMPEG installed and it's highly recommended that you use [paperclip-ffmpeg](https://github.com/owahab/paperclip-ffmpeg) too (since you'll want the transcoding features anyways). See paperclip-ffmpeg's documentation for information on installing FFMPEG.

In your model

  ```ruby
  class Lesson
    has_attached_file :video, :styles => {
      :web => { :geometry => "640x480", :format => 'mp4' }
    }, :processors => [:ffmpeg, :normalize]
  end
  ```

Thanks to [Chris Vaill](http://normalize.nongnu.org/README.html) for writing normalize-audio. None of this would work without him.