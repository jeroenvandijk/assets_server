class AssetsController < ApplicationController
  include AssetsServer
  
  def serve
    path = params[:path]

    response = lambda { |format| render :inline => render_asset(path, format, :inline => true)  }

    respond_to do |format|
      format.js  { response.call(:js) }
      format.css { response.call(:css) }
    end
  end
  
end
