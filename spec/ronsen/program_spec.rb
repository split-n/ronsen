require 'spec_helper'

describe Ronsen::Program do
  describe ".parse_entire_xml" do
    subject { -> { Ronsen::Program.parse_entire_xml(xml) } }
    context "load programs.xml" do
      let(:xml) {
        xml_path = Pathname.new(__dir__) + "../fixtures/programs.xml"
        xml_path.read
      }
      let(:programs_count) { 81 }
      it { expect(subject.call.count).to eq programs_count }
    end

    context "no programs in xml" do
      let(:xml) { '<?xml version="1.0" encoding="UTF-8"?>' }
      it { is_expected.to raise_error }
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
