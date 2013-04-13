require 'spec_helper'

describe Tmx::Object do
  context "when created with standard parameters" do

    let(:object) do
      Tmx::Object.new points: points, type: "rock"
    end

    #
    # These are the points as they are currently defined
    # in the TMX gem for a poly shape
    #
    let(:points) { ["320,448", "1248,448", "1248,480", "320,480"] }

    describe "#body" do
      let(:body) { object.body }

      it "has infinite mass" do
        expect(body.m).to eq Float::INFINITY
      end

      it "has infinite moment of interia" do
        expect(body.i).to eq Float::INFINITY
      end
    end

    describe "#shape" do
      let(:shape) { object.shape }

      it "body should be the same body" do
        expect(shape.body).to eq object.body
      end

      it "has correct collision type" do
        expect(shape.collision_type).to eq :rock
      end

      it "not a sensor" do
        expect(shape).to_not be_sensor
      end

      it "has no elasticity" do
        expect(shape.e).to eq 0.0
      end
    end
  end

end