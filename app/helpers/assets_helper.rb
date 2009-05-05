module AssetsHelper
  include AssetsServer
  
  def include_assets(*types)
    options = {:wrap => true }.merge(types.extract_options!)
    
    relative_path = File.join(params[:controller], params[:action])
    types.collect{ |type| render_asset(relative_path, type, options) }.join("\n")
  end  

end
