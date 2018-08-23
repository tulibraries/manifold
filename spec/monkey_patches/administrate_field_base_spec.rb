# We can't test base field directly, so we'll test our
# monkey patch on a field that inherits from it
require 'rails_helper'
require 'administrate/field/string'

describe Administrate::Field::String do
  let(:field){ Administrate::Field::String.new(:string, "hello", :new, (options|| {})) }

  describe "#html_attributes" do
    context "html_attributes option is passed" do
      let(:options){ { html_attributes: { foo: "bar" }}}
      it "returns the expected value" do
        expect(field.html_attributes).to eql({foo: "bar"})
      end
    end

    context "html_attributes option is not passed" do
      let(:options){ {} }
      it "returns the expected value" do
        expect(field.html_attributes).to eql({})
      end
    end

    context "if required option is passed, html_attributes includes extra attributes" do
      let(:options){ {required: true, html_attributes: {foo: "bar2"}} }
      it "returns the expected value" do
        expect(field.html_attributes).to include(:foo, :aria, :required)
      end
    end


  end

  describe "#public_options" do
    let(:options) {{foo: "bar"}}
    it "returns the expected value" do
      expect(field.public_options).to eql({foo: "bar"})
    end
  end

  describe "#required?" do
    context 'required option passed is true' do
      let(:options) { {required: true}}
      it "is true" do
        expect(field.required?).to be true
      end
    end

    context 'required option passed is "required"' do
      let(:options) { {required: "required"}}
      it "is true" do
        expect(field.required?).to be true
      end
    end

    context 'required option passed is false' do
      let(:options) { {required: false}}
      it "is fasle" do
        expect(field.required?).to be false
      end
    end

    context 'required option is not passed' do
      let(:options) { {}}
      it "is false" do
        expect(field.required?).to be false
      end
    end
  end
end
