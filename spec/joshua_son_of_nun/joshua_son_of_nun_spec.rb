require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")
require 'joshua_son_of_nun/joshua_son_of_nun'

describe JoshuaSonOfNun::JoshuaSonOfNun do

  it "should be instantiable with no paramters" do

    lambda { JoshuaSonOfNun::JoshuaSonOfNun.new }.should_not raise_error

  end

end