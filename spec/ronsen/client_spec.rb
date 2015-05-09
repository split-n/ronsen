require 'spec_helper'

describe Ronsen::Client do
  let(:accessor) { double("accessor mock") }
  let(:client) { Ronsen::Client.new(accessor) }

  context "with programs.xml" do
    let(:programs_xml) {
      xml_path = Pathname.new(__dir__) + "../fixtures/programs.xml"
      xml_path.read
    }

    before do
      allow(accessor).to receive(:get_programs_xml).and_return(programs_xml)
    end

    describe "#get_all_programs" do
      let(:all_programs_count) { 81 }
      subject { client.get_all_programs }

      it { expect(subject.count).to eq all_programs_count }
    end

    describe "#get_active_programs" do
      let(:active_programs_count) { 71 }
      subject { client.get_active_programs }

      it { expect(subject.count).to eq active_programs_count }
    end
  end

  context "Bad connection" do
    before do
      allow(accessor).to receive(:get_programs_xml).and_raise(Ronsen::ConnectionError)
    end

    describe "#get_all_programs" do
      subject { -> { client.get_all_programs } }

      it "through error" do
        is_expected.to raise_error Ronsen::ConnectionError
      end
    end

    describe "#get_active_programs" do
      subject { -> { client.get_active_programs } }

      it "throwgh error" do
        is_expected.to raise_error Ronsen::ConnectionError
      end
    end

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
