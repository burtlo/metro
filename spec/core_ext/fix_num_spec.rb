require 'spec_helper'

describe Fixnum do

  describe "#tick(s)" do
    subject { 60 }
    let(:expected_value) { 60 }

    its(:tick) { should eq expected_value }
    its(:ticks) { should eq expected_value }
  end

  describe "#second(s)" do
    context "when the tick interval has not been set" do
      subject { 2 }
      let(:expected_value) { 120 }

      its(:second) { should eq expected_value }
      its(:seconds) { should eq expected_value }
      its(:sec) { should eq expected_value }
      its(:secs) { should eq expected_value }
    end

    context "when the tick interval has been set" do
      before do
        Fixnum.tick_interval = 33.333333
      end

      subject { 3 }
      let(:expected_value) {90 }

      its(:second) { should eq expected_value }
      its(:seconds) { should eq expected_value }
    end
  end

end