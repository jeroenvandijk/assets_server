module AssetsHelper
  include AssetsServer
  
  def include_assets(*types)
    options = {:wrap => true }.merge(types.extract_options!)

    relative_path = File.join(params[:controller], params[:action])
    types.collect{ |type| render_asset(relative_path, type, options) }.join("\n")
  end


  def html_id
    "#{controller.controller_name}-#{controller.action_name}"
  end

  def body_class
    "#{controller.controller_name} #{controller.controller_name}-#{controller.action_name}"
  end
end