require File.expand_path(File.dirname(__FILE__)) + '/spec_helper'

class AssetService
  include AssetsServer
  
  def render(hash)
    hash[:inline]
  end
end

describe "AssetServer" do
  subject { AssetService.new }
  
  def path(type)
    RAILS_ROOT + "/app/assets/#{type}/users/monkey"
  end
  
  describe "#render_asset when there is an erb extension" do
    it "should return parsed css when there exist a monkey.sass.erb" do
      path = "#{path("stylesheets")}.sass"
      path_with_erb = path + ".erb"
      FileTest.stubs(:exists?).returns(false)
      FileTest.expects(:exists?).with(path).returns(false)
      FileTest.expects(:exists?).with(path_with_erb).returns(true)
      
      File.expects(:open).with(path_with_erb, 'r').returns(mock(:read => ":background-color color"))
      subject.render_asset("users/monkey", :css, :inline => true).should eql "html#users-monkey {\n  background-color: color; }\n"
    end
    

    
  end
    
  describe "#render_asset" do
    it "should return parsed css when there exist a monkey.sass" do
      FileTest.stubs(:exists?).returns(false)
      FileTest.expects(:exists?).with("#{path("stylesheets")}.sass").returns(true)
      File.expects(:open).returns(mock(:read => ":background-color color"))
      subject.render_asset("users/monkey", :css, :inline => true).should eql "html#users-monkey {\n  background-color: color; }\n"
    end
    
    it "should return css when there exist a monkey.css" do
      FileTest.expects(:exists?).with("#{path("stylesheets")}.css").returns(true)
      File.expects(:open).returns(mock(:read => "background-color: { red };"))
      subject.render_asset("users/monkey", :css, :inline => true).should eql "background-color: { red };"
    end
    
    it "should return javascript when there exist a monkey.js" do
      FileTest.expects(:exists?).with("#{path("javascripts")}.js").returns(true)
      File.expects(:open).returns(mock(:read => "test"))
      subject.render_asset("users/monkey", :js, :inline => true).should eql "test"
    end
  end
  
  describe "sass" do
    describe "shared mixins" do
      require 'sass'
      module Sass::Plugin
        class << self
          attr_accessor :options
        end
        self.options = {}
      end


      it "should include shared mixins" do
        pending
        load_path = "app/assets/stylesheets/application"

        Sass::Plugin.options[:load_paths] = load_path
      
        base_path = File.join(RAILS_ROOT, load_path, "partials/_base.sass")
        FileTest.expects(:exists?).with(base_path).returns(true)

        File.expects(:open).with(base_path, "r").returns(mock(:read => "=bg\n  :background color"))

        FileTest.expects(:exists?).with("#{path("stylesheets")}.sass").returns(true)
        File.expects(:open).returns(mock(:read => ".test\n  +bg"))
        subject.render_asset("users/monkey", :css, :inline => true)#.should eql "html#users-monkey .test {\n  background-color: color; }\n"
      end

      
    end
  end
  
end