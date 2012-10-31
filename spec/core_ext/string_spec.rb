require 'spec_helper'

describe String do

  describe "#underscore" do
    context "when given a regular string" do
      subject { "String" }
      let(:expected_value) { "string" }

      its(:underscore) { should eq expected_value }
    end

    context "when given an already snake cased string" do
      subject { "underscored" }
      let(:expected_value) { "underscored" }

      its(:underscore) { should eq expected_value }
    end

    context "when given a camelCased string" do
      subject { "SnakeCased" }
      let(:expected_value) { "snake_cased" }

      its(:underscore) { should eq expected_value }
    end

    context "when given a partial camel_Cased string" do
      subject { "snake_Cased" }
      let(:expected_value) { "snake_cased" }
      its(:underscore) { should eq expected_value }
    end
  end

  describe "#classify" do
    context "when given a regular string" do
      subject { "string" }
      let(:expected_value) { "String" }
      its(:classify) { should eq expected_value }
    end

    context "when given a underscored string" do
      subject { "camel_cased" }
      let(:expected_value) { "CamelCased" }
      its(:classify) { should eq expected_value }
    end

    context "when given a partial camel_CasedString" do
      subject { "camel_CasedString" }
      let(:expected_value) { "CamelCasedString" }
      its(:classify) { should eq expected_value }
    end
  end
end