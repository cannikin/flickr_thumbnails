#class Array
#  def randomize
#    duplicated_original, new_array = self.dup, self.class.new
#    new_array << duplicated_original.slice!(rand(duplicated_original.size)) until new_array.size.eql?(self.size)
#    new_array
#  end
#
#  def randomize!
#    self.replace(randomize)
#  end
#end

module FlickrTags
  
  include Radiant::Taggable
  
  ATTRIBUTES = %w{api_key user_id tags tag_mode text min_upload_date max_upload_date min_taken_date max_taken_date license sort privacy_filter bbox accuracy safe_search content_type machine_tags machine_tag_mode group_id contacts woe_id place_id media has_geo geo_context lat lon radius radius_units is_commons extras per_page page}
  URL_BASE = 'http://api.flickr.com/services/rest?&method=flickr.photos.search&format=json&nojsoncallback=1'

  tag 'flickr' do |tag|
    url = URL_BASE
    random = tag.attr['random'] || false
    
    if random
      total = tag.attr['per_page'].to_i
      tag.attr['per_page'] = '100'
    else
      total = tag.attr['per_page'].to_i
    end
    
    # add all attributes to the query string
    ATTRIBUTES.each do |a|
      url += "&#{a}=#{CGI::escape(tag.attr[a].to_s)}" if tag.attr[a]
    end
    
    output = ''
    begin
      json = Net::HTTP.get(URI.parse(url))
      result = ActiveSupport::JSON.decode(json)
      photos = result['photos']['photo']
      output += photos.randomize.inspect.to_s
      # output += photos.shuffle.inspect
      unless photos.empty?
        # photos.randomize! if random
        # output += random.to_s + ' ' + total
        # output += photos.respond_to?('shuffle').to_s
        output += '<ul>'
        photos[0..total-1].each do |photo|
          thumb = "http://farm#{photo['farm']}.static.flickr.com/#{photo['server']}/#{photo['id']}_#{photo['secret']}_s.jpg"
          output += %{<li><a href="http://flickr.com/photos/cannikin/#{photo['id']}"><img src="#{thumb}" alt="#{photo['title']}" /></a></li>}
        end
        output += '</ul>'
      end
    rescue
      # any problems with request just output nothing
    end
    
    output
  end

end
