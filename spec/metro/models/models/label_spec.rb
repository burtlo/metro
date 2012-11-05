require 'spec_helper'

describe Metro::Models::Label do
  
  let(:expected_position) { Metro::Point.new 320, 240 }
  its(:position) { should eq expected_position }
  
  context "when setting the position" do
  
    it "should be set succesfully" do
      subject.position = "10,10"
      subject.position.should eq Metro::Point.new 10, 10
    end
  
    context "when setting the x property" do
      let(:expected_x) { 11 }
      let(:expected_y) { 240 }
  
      it "should update successfully" do
        subject.x = expected_x
        subject.x.should eq expected_x
        subject.position.x.should eq expected_x
      end
  
      it "should not effect the paired y property" do
        subject.x = expected_x
        subject.y.should eq expected_y
        subject.position.y.should eq expected_y
      end
    end
  
    context "when setting the y property" do
      let(:expected_x) { 320 }
      let(:expected_y) { 66 }
  
      it "should update successfully" do
        subject.y = expected_y
        subject.y.should eq expected_y
        subject.position.y.should eq expected_y
      end
  
      it "should not effect the paired x property" do
        subject.y = expected_y
        subject.x.should eq expected_x
      end
    end
  
  end
  
  its(:x) { should eq expected_position.x }
  its(:y) { should eq expected_position.y }
  
  its(:scaleable) { should eq Metro::Scale.default }
  
  context "when setting the scale" do
    it "should set" do
      subject.x_factor = 2.0
      subject.x_factor.should eq 2.0
      subject.scaleable.x_factor.should eq 2.0
    end
  end

end