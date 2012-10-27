require 'spec_helper'

describe String do

  describe "#snake_case" do
    context "when given a regular string" do
      subject { "String" }
      let(:expected_value) { "string" }

      its(:snake_case) { should eq expected_value }
    end

    context "when given an already snake cased string" do
      subject { "snake_cased" }
      let(:expected_value) { "snake_cased" }

      its(:snake_case) { should eq expected_value }
    end

    context "when given a camelCased string" do
      subject { "SnakeCased" }
      let(:expected_value) { "snake_cased" }

      its(:snake_case) { should eq expected_value }
    end

    context "when given a partial camel_Cased string" do
      subject { "snake_Cased" }
      let(:expected_value) { "snake_cased" }
      its(:snake_case) { should eq expected_value }
    end
  end

  describe "#camel_case" do
    context "when given a regular string" do
      subject { "string" }
      let(:expected_value) { "String" }
      its(:camel_case) { should eq expected_value }
    end

    context "when given a snake_cased string" do
      subject { "camel_cased" }
      let(:expected_value) { "CamelCased" }
      its(:camel_case) { should eq expected_value }
    end

    context "when given a partial camel_CasedString" do
      subject { "camel_CasedString" }
      let(:expected_value) { "CamelCasedstring" }
      its(:camel_case) { should eq expected_value }
    end
  end
end