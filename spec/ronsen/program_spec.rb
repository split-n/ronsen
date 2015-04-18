require 'spec_helper'

describe Ronsen::Program do
  describe "Class" do
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
  end

  describe "Instance" do
    shared_context "program1.xml" do
      let(:xml) {
        xml_path = Pathname.new(__dir__) + "../fixtures/program1.xml"
        Nokogiri.parse(xml_path.read).xpath("//program").first
      }
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
      context "load program1.xml" do
        include_context "program1.xml"
        it { expect(subject.call).to be_a Ronsen::Program }
      end
    end

    context "initialized by program1.xml" do
      include_context "program1.xml"
      let(:instance) { Ronsen::Program.new(xml) }

      describe "#id" do
        subject { instance.id }
        let(:correct_id) { "shirobako" }
        it { is_expected.to eq correct_id }
      end

      describe "#original_xml" do
        subject { instance.original_xml }
        it { is_expected.to include '<program id="shirobako">' }
      end

      describe "#as_hash" do
        %w(title copyright is_app movie_url up_date).each do |tagname|
          it "should eq #{tagname}" do
            expect(instance.as_hash[tagname]).to eq xml.xpath("//#{tagname}").first.text
          end
        end


      end
    end
  end
end
