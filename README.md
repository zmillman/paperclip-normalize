# Paperclip Normalize #

THIS GEM IS NOT IMPLEMENTED. DO NOT USE IT YET!

Add an audio normalization processor to Paperclip.

This gem has been developed for use with Ubuntu. Your mileage may vary on other systems.

## About Audio Normalization ##

Audio normalization is the process of adjusting the volume of a track to bring the loudness to a target level.

This is particularly useful for making sure that all of the files that you upload are audible without the user having to adjust the volume on a track-by-track basis.

## Installation ##

Add to your Gemfile:

```ruby
gem "paperclip-normalize", :git => "git://github.com/zmillman/paperclip-normalize.git"
```
  
normalize-audio must also be installed and Paperclip must have access to it.

```
sudo apt-get install normalize-audio
```

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

`paperclip-normalize` also detects video file formats and works with FFMPEG to normalize the audio track. See [paperclip-ffmpeg's documentation](https://github.com/owahab/paperclip-ffmpeg) for information on installing and using FFMPEG.

In your model:

```ruby
class Lesson
  has_attached_file :video, :styles => {
    :web => { :geometry => "640x480", :format => 'mp4' }
  }, :processors => [:ffmpeg, :normalize]
end
```

This will produce a transcoded `:web` mp4 with the audio track normalized to 0dB.

## Kudos ##

Thanks to Chris Vaill for writing [normalize-audio](http://normalize.nongnu.org/README.html). None of this would work without him.