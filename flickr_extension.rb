require 'open-uri'
require 'activesupport'

class FlickrExtension < Radiant::Extension
  version "1.0"
  description "Pulls thumbnails from flickr for display"
  url "http://ridingtheclutch.com/flickr"

  def activate
    Page.send :include, FlickrTags
  end
  
  def deactivate
  end
  
end
