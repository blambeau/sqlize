require File.expand_path('../spec_helper', __FILE__)
describe SQLize do
  
  it "should have a version number" do
    SQLize.const_defined?(:VERSION).should be_true
  end
  
end
