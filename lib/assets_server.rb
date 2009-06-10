module AssetsServer

  def render_asset(path, type_sym, options)
    type = type_sym.to_s
    
    return "" unless template_path = find_template(path, type)
    
    if options[:inline]
      render_asset_inline(template_path, type, :wrap => options[:wrap])
      
    else
      render_asset_tag(path, type)
    end
  end
  
  def render_asset_inline(template_path, type, options = {})
    # template_path += ".erb" if asset_exists?(template_path + ".erb")
    inline_asset = render_file(template_path)
    parsed_asset = (type == 'css' ? render_css_or_sass(inline_asset, template_path) : inline_asset)

    if options[:wrap]
      case type
      when 'js'   : javascript_tag( parsed_asset )
      when 'css'  : css_tag( parsed_asset )
      end
    else
      parsed_asset
    end
  end
  
  def render_asset_tag(path, type)
    timestamp = "?" + Time.now.to_i.to_s if RAILS_ENV =="development" # REVIEW Necessary?
    relative_dir = File.join(assets_dir, path + ".#{type}#{timestamp}")
    
    case type
      when 'js'   : javascript_include_tag(relative_dir)
      when 'css'  : stylesheet_link_tag(relative_dir)
    end
  end
  
  def find_template(path, type)
    extensions = [".#{type}"]
    extensions << ".sass" if type == "css"
    
    extensions.each do |ext|
      path_with_ext = path + ext
      
      return path_with_ext if asset_exists?(path_with_ext)
      return path_with_ext + ".erb" if asset_exists?(path_with_ext + ".erb")
    end
    
    nil
  end

  def asset_exists?(path_without_extension)
    FileTest.exists?(absolute_path(path_without_extension))
  end

  def render_file(relative_path)
    args = { :inline => File.open(absolute_path(relative_path), "r").read }
    
    respond_to?(:render_to_string) ? render_to_string(args) : render(args)
  end
  
  def render_css_or_sass(inline_asset, path)
    path.slice(/sass/) ? render_sass(inline_asset, path) : inline_asset 
  end

  def render_sass(file_content, path)
    indention = "  "
    
    nested_file_content = ""
    nested_file_content << "@import partials/base.sass\n" if FileTest.exists?(File.join(RAILS_ROOT, "app", assets_dir, "stylesheets", "application", "partials/_base.sass")) # TODO Remove magic variables
    nested_file_content << "#{namespace(path)}\n"
    nested_file_content << indention << file_content.gsub("\n", "\n#{indention}")
    Sass::Engine.new( nested_file_content, Sass::Plugin.options).render    
  end

  def namespace(path)
    'html#' + path.gsub(/\/|\\/, '-').split('.').first
  end

  def css_tag(css)
    %{<style type="text/css">\n#{css}\n</style>}
  end

  def absolute_path(relative_path)
    type = relative_path.slice(/sass|css|js/)  

    RAILS_ROOT + "/app#{type_dir(relative_path, type)}"
  end
  
  def assets_dir
    "/assets/"
  end
  
  def type_dir(relative_path, type)
    relative_type_dir = lambda { |type_sub_dir| "#{assets_dir}#{type_sub_dir}/#{relative_path}" }

    case type.to_s
      when 'js'   : relative_type_dir.call("javascripts")
      when /css|sass/  : relative_type_dir.call("stylesheets")
    end
  end
end