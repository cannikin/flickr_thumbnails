namespace :radiant do
  namespace :extensions do
    namespace :flickr do
      
      desc "Runs the migration of the Flickr extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          FlickrExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          FlickrExtension.migrator.migrate
        end
      end
      
      desc "Copies public assets of the Flickr to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        puts "Copying assets from FlickrExtension"
        Dir[FlickrExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(FlickrExtension.root, '')
          directory = File.dirname(path)
          mkdir_p RAILS_ROOT + directory
          cp file, RAILS_ROOT + path
        end
      end  
    end
  end
end
