require 'spec_helper'

describe Ronsen::Program do
  describe "class methods" do
    it "can parse all programs" do
      xml_path = Pathname.new(__dir__) + "../fixtures/programs.xml"
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

  describe "#initialize" do
    subject { -> { Ronsen::Program.new(xml) } }
    context "arg is nil" do
      let(:xml) { nil }
      it { is_expected.to raise_error }
    end

    context "arg is string" do
      let(:xml) { "<?xml>" }
      it { is_expected.to raise_error }
    end

    context "arg not contains <program>" do
      let(:xml) {
        xml_str = <<-'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<programs>
</programs>
        EOF
        Nokogiri.parse(xml_str)
      }
      it { is_expected.to raise_error }
    end

  end
end
