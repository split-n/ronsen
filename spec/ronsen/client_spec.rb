require 'spec_helper'

describe Ronsen::Client do
  let(:accessor) { double("accessor mock") }
  let(:client) { Ronsen::Client.new(accessor) }
  describe "#get_all_programs" do
  end

  describe "#get_active_programs" do

  end

  describe "#user_agent=" do
    let(:ua) { "uaua" }
    before do
      allow(accessor).to receive(:user_agent=)
    end

    it "should set success" do
      expect(accessor).to receive(:user_agent=).with(ua)
      client.user_agent = ua
    end
  end
end
