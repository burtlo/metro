require 'spec_helper'

describe Metro::UI::Label do

  subject do
    label = described_class.new text: expected_text
    label.window = mock('window')
    label
  end

  before do
    # Reset the position of the label to the default
    subject.position = nil
    subject.scale = Scale.one
  end

  let(:expected_position) { Point.zero }
  its(:position) { should eq expected_position }

  its(:x) { should eq expected_position.x }
  its(:y) { should eq expected_position.y }
  its(:z) { should eq expected_position.z }
  its(:z_order) { should eq expected_position.z_order }

  context "when setting the position" do

    it "should be set succesfully" do
      subject.position = "10,10"
      subject.position.should eq Point.at(10,10)
    end

    context "when setting the x property" do
      let(:expected_x) { 11 }
      let(:expected_y) { 0 }

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
      before do
        subject.position = "#{expected_x},#{expected_y}"
      end

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

  let(:expected_color) { Gosu::Color.new "rgb(255,255,255)" }
  let(:expected_alpha) { 255 }

  its(:color) { should eq expected_color }
  its(:alpha) { should eq expected_alpha }

  describe "font" do
    before do
      Metro::Font.stub(:find_or_create).and_return(font)
    end

    let(:font) { mock('font', name: expected_font_name, size: expected_font_size) }

    let(:expected_font) { font }
    its(:font) { should eq expected_font }

    let(:expected_font_name) { 'mock_font_name' }
    its(:font_name) { should eq expected_font_name }

    let(:expected_font_size) { 12.0 }
    its(:font_size) { should eq expected_font_size }

  end

  let(:expected_scale) { Scale.one }

  its(:scale) { should eq expected_scale }
  its(:x_factor) { should eq expected_scale.x_factor }
  its(:y_factor) { should eq expected_scale.y_factor }

  context "when setting the scale" do
    it "should be set successfully" do
      subject.x_factor = 2.0
      subject.x_factor.should eq 2.0
      subject.scale.x_factor.should eq 2.0
    end
  end

  its(:align) { should eq expected_horizontal_alignment }
  let(:expected_horizontal_alignment) { "left" }

  its(:vertical_align) { should eq expected_vertical_alignment }
  let(:expected_vertical_alignment) { "top" }

  its(:text) { should eq expected_text }
  let(:expected_text) { "Four Score and Seven Years Ago" }

  context "when the text defines multiple lines (lines separated by newline characters)" do

    let(:given_text) { "My name is something that takes\ntwo lines to express!" }
    let(:first_line) { given_text.split("\n").first }
    let(:last_line)  { given_text.split("\n").last }

    let(:x_position) { 320 }
    let(:y_position) { 200 }
    let(:z_order) { 12 }

    let(:scale_x) { 1.0 }
    let(:scale_y) { 1.0 }

    let(:font) { mock('font') }

    let(:line_height) { 20 }

    before do
      subject.text = given_text
      subject.position = Point.at(x_position,y_position,z_order)
      subject.scale = Scale.to(scale_x,scale_y)
      subject.stub(:font).and_return(font)
      subject.stub(:line_height) { line_height }
    end

    it "should have the font draw each of the lines" do
      font.should_receive(:draw).twice
      subject.draw
    end

    context "when the horizontal alignment is center" do

      before do
        subject.align = "center"
        subject.vertical_align = "top"
        subject.stub(:line_width).with(first_line) { 60 }
        subject.stub(:line_width).with(last_line) { 42 }
      end

      let(:first_line_x_position) { x_position - 30 }
      let(:second_line_x_position) { x_position - 21 }

      let(:first_line_y_position) { y_position }
      let(:second_line_y_position) { y_position + line_height }

      it "should draw the lines correctly based on their on their respective widths" do
        font.should_receive(:draw).with(first_line,first_line_x_position,first_line_y_position,z_order,scale_x,scale_y,an_instance_of(Gosu::Color))
        font.should_receive(:draw).with(last_line,second_line_x_position,second_line_y_position,z_order,scale_x,scale_y,an_instance_of(Gosu::Color))
        subject.draw
      end

    end

    context "when the horizontal alignment is right" do

      before do
        subject.align = "right"
        subject.vertical_align = "top"
        subject.stub(:line_width).with(first_line) { 60 }
        subject.stub(:line_width).with(last_line) { 42 }
      end

      let(:first_line_x_position) { x_position - 60 }
      let(:second_line_x_position) { x_position - 42 }

      let(:first_line_y_position) { y_position }
      let(:second_line_y_position) { y_position + line_height }

      it "should draw the lines correctly based on their on their respective widths" do
        font.should_receive(:draw).with(first_line,first_line_x_position,first_line_y_position,z_order,scale_x,scale_y,an_instance_of(Gosu::Color))
        font.should_receive(:draw).with(last_line,second_line_x_position,second_line_y_position,z_order,scale_x,scale_y,an_instance_of(Gosu::Color))
        subject.draw
      end

    end

    context "when the vertical alignment is top" do

      before do
        subject.vertical_align = "top"
      end

      let(:first_line_y_position) { y_position }
      let(:second_line_y_position) { y_position + line_height }

      it "should draw the first line at the y position" do
        font.should_receive(:draw).with(first_line,x_position,first_line_y_position,z_order,scale_x,scale_y,an_instance_of(Gosu::Color))
        font.should_receive(:draw).with(last_line,x_position,second_line_y_position,z_order,scale_x,scale_y,an_instance_of(Gosu::Color))
        subject.draw
      end

    end

    context "when the vertical alignment is center" do

      before do
        subject.text = text
        subject.vertical_align = "center"
      end

      let(:text) { "Three Lines\nOf Text\nWill Create Fun!" }


      let(:first_line) { text.split("\n")[0] }
      let(:second_line) { text.split("\n")[1] }
      let(:third_line) { text.split("\n")[2] }


      let(:first_line_y_position) { y_position - line_height - line_height / 2 }
      let(:second_line_y_position) { y_position - line_height / 2 }
      let(:third_line_y_position) { y_position + line_height / 2 }

      it "should draw the first line at the y position" do
        font.should_receive(:draw).with(first_line,x_position,first_line_y_position,z_order,scale_x,scale_y,an_instance_of(Gosu::Color))
        font.should_receive(:draw).with(second_line,x_position,second_line_y_position,z_order,scale_x,scale_y,an_instance_of(Gosu::Color))
        font.should_receive(:draw).with(third_line,x_position,third_line_y_position,z_order,scale_x,scale_y,an_instance_of(Gosu::Color))
        subject.draw
      end

    end

    context "when the vertical alignment is bottom" do

      before do
        subject.vertical_align = "bottom"
      end

      let(:first_line_y_position) { y_position - line_height * 2 }
      let(:second_line_y_position) { y_position - line_height }

      it "should draw the first line at the y position" do
        font.should_receive(:draw).with(first_line,x_position,first_line_y_position,z_order,scale_x,scale_y,an_instance_of(Gosu::Color))
        font.should_receive(:draw).with(last_line,x_position,second_line_y_position,z_order,scale_x,scale_y,an_instance_of(Gosu::Color))
        subject.draw
      end

    end

  end


end