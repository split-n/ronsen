require 'spec_helper'

describe Ronsen::Program do
  describe "class methods" do
    it "can parse all programs" do
      xml_path = Pathname.new(__dir__) + "../assets/programs.xml"
      xml = xml_path.read

      programs = Ronsen::Program.parse_entire_xml(xml)

      expect(programs.count).to eq 81
    end

    it "raise exception if no programs" do
      xml = '<?xml version="1.0" encoding="UTF-8"?>'
      expect {
        Ronsen::Program.parse_entire_xml(xml)
      }.to raise_error
    end



  end
end
