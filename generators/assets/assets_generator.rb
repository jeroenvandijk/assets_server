class AssetsGenerator < Rails::Generator::NamedBase	
	def manifest
      types = { 'js' => 'javascripts', 
                ( Object.const_defined?("Sass") ? 'sass' : 'css') => 'stylesheets' }
      
      record do |m|
        
        types.each_pair do |ext, name|
          asset_root = "app/assets/#{name}"

          m.directory( File.join(asset_root, "application") )
          
          path = File.join(asset_root, class_path.to_s, plural_name)
          m.directory( path )
        
          %w(index show new edit).each do |action|
            m.template("template.rb",
                       File.join(path, "#{action}.#{ext}.erb"),
                       :assigns => { :asset_name => name, :action => action })
          end
          
        end
        
  	end
	end
end