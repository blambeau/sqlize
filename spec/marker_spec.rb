require File.expand_path('../spec_helper', __FILE__)
module SQLize
  describe Marker do

    it "should be implement a valid type" do
      [Marker.new(:a), Marker.new(:a)].uniq.size.should == 1
      h = {Marker::DROP => 1, Marker::DROP => 2}
      h.size.should == 1
    end

    it "should have a suppremum function" do
      (Marker::DROP | Marker::CREATE).should == Marker::ALTER
      #
      (Marker::DROP | Marker::DROP).should == Marker::DROP
      (Marker::CREATE | Marker::CREATE).should == Marker::CREATE
      (Marker::ALTER | Marker::ALTER).should == Marker::ALTER
      #
      (Marker::ALTER | Marker::DROP).should == Marker::ALTER
      (Marker::ALTER | Marker::CREATE).should == Marker::ALTER
      #
      (Marker::ALTER | Marker::UNCHANGED).should == Marker::ALTER
      (Marker::DROP | Marker::UNCHANGED).should == Marker::DROP
      (Marker::CREATE | Marker::UNCHANGED).should == Marker::CREATE
    end

  end
end
