require 'spec_helper'

describe Metro::Units::Point do

  subject { described_class.new x, y, z }

  let(:x) { 12 }
  let(:y) { 24 }
  let(:z) { 36 }

  its(:x) { should eq x }
  its(:y) { should eq y }
  its(:z) { should eq z }
  its(:z_order) { should eq z }

  let(:expected_string) { "#{x},#{y},#{z}" }
  its(:to_s) { should eq expected_string }

  describe "#+" do
    context "when adding it to another point" do
      let(:point) { described_class.at 1, 2, 3 }
      let(:summed_point) { described_class.at 13, 26, 39 }

      it "should be a sum of the two points" do
        sum = subject + point
        sum.should eq summed_point
      end
    end

    context "when adding it to another point-like object" do
      let(:point) { double('Point Like',x: 1, y: 2, z: 3) }
      let(:summed_point) { described_class.at 13, 26, 39 }

      it "should be a sum of the two points" do
        sum = subject + point
        sum.should eq summed_point
      end
    end

    context "when adding it to something not like a point" do
      let(:point) { double('Not Point Like') }
      let(:summed_point) { described_class.at 13, 26, 39 }

      it "should raise an error" do
        expect { subject + point }.to raise_error
      end
    end
  end

  describe "#-" do
    context "when adding it to another point" do
      let(:point) { described_class.at 1, 2, 3 }
      let(:summed_point) { described_class.at 11, 22, 33 }

      it "should be a sum of the two points" do
        sum = subject - point
        sum.should eq summed_point
      end
    end

    context "when adding it to another point-like object" do
      let(:point) { double('Point Like',x: 1, y: 2, z: 3) }
      let(:summed_point) { described_class.at 11, 22, 33 }

      it "should be a sum of the two points" do
        sum = subject - point
        sum.should eq summed_point
      end
    end

    context "when adding it to something not like a point" do
      let(:point) { double('Not Point Like') }
      let(:summed_point) { described_class.at 13, 26, 39 }

      it "should raise an error" do
        expect { subject - point }.to raise_error
      end
    end
  end

  describe "Class Methods" do

    subject { described_class }

    describe "#zero" do
      let(:expected_point) { Point.new 0,0,0 }

      it "should create a zero point" do
        subject.zero.should == expected_point
      end
    end

    describe "#at" do
      let(:expected_point) { Point.new 1,2,3 }

      it "should be equal to a new created point" do
        subject.at(1,2,3).should == expected_point
      end
    end

    describe "#parse" do
      context "when the input string is defined with 'x,y,z'" do
        let(:input) { "1,2,3" }
        let(:expected_value) { Point.at(1,2,3) }

        it "should create the expected point" do
          subject.parse(input).should eq expected_value
        end
      end

      context "when the input string is defined with 'x,y'" do
        let(:input) { "1,2" }
        let(:expected_value) { Point.at(1,2,0) }

        it "should create the expected point" do
          subject.parse(input).should eq expected_value
        end
      end

      context "when the input is a nil" do
        let(:input) { nil }
        let(:expected_value) { Point.at(0,0,0) }

        it "should create the expected point" do
          subject.parse(input).should eq expected_value
        end
      end
    end

  end

end
