ActionController::Routing::Routes.draw do |map|
  map.connect '/assets/:path.:format', :controller => 'assets', :action => 'serve', :requirements => { :path => /\w+(\/\w+)+/ }
end