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
        it { is_expected.to raise_error Ronsen::ResponseParseError }
      end
    end

    describe "new" do
      let(:xml) {
        xml_path = Pathname.new(__dir__) + "../fixtures/program1.xml"
        Nokogiri.parse(xml_path.read).xpath("//program").first
      }
      subject { -> { Ronsen::Program.new(xml) } }

      context "arg is nil" do
        let(:xml) { nil }
        it { is_expected.to raise_error Ronsen::ResponseParseError }
      end

      context "arg is string" do
        let(:xml) { "<?xml>" }
        it { is_expected.to raise_error Ronsen::ResponseParseError}
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
        it { is_expected.to raise_error Ronsen::ResponseParseError}
      end
      context "load program1.xml" do
        it { expect(subject.call).to be_a Ronsen::Program }
      end
    end
  end


  describe "Instance" do
    let(:instance) { Ronsen::Program.new(xml) }

    shared_examples_for "Instance's methods" do

      describe "#id" do
        subject { instance.id }
        it { is_expected.to eq expected_id }
      end

      describe "#original_xml" do
        subject { instance.original_xml }
        it { is_expected.to include expected_original_xml_includes }
      end

      describe "#as_hash" do
        %w(title copyright is_app movie_url up_date).each do |tagname|
          it "should eq #{tagname}" do
            expect(instance.as_hash[tagname]).to eq xml.xpath("//#{tagname}").first.text
          end
        end

          it "should eq personalities" do
            expect(
              instance.as_hash["personalities"]["personality"].map{|p| p["name"]}
            ).to eq(
              xml.css("personalities>personality>name").map{|p| p.text}
            )
        end
      end

      describe "#banner_image_url" do
        subject { instance.banner_image_url }
        it { is_expected.to eq expected_banner_image_url }
      end


      describe "#can_download?" do
        subject { instance.can_download? }
        it { is_expected.to eq expected_can_download }
      end
    end

    shared_examples_for "Normal Instance's methods" do
      describe "#pretty_filename" do
        subject { instance.pretty_filename }
        it { is_expected.to eq expected_pretty_filename }
      end

      describe "#download" do
        subject {
          stub = stub_request(:get, expected_download_url)
            .to_return(status: 200, body: "")
          instance.download
          stub
        }

        it "requests correct url" do
          is_expected.to have_been_requested
        end
      end
    end

    context "initialized by program1.xml" do
      let(:xml) {
        xml_path = Pathname.new(__dir__) + "../fixtures/program1.xml"
        Nokogiri.parse(xml_path.read).xpath("//program").first
      }

      let(:expected_id) { "shirobako" }
      let(:expected_original_xml_includes) { '<program id="shirobako">' }
      let(:expected_banner_image_url) { "http://www.onsen.ag/program/shirobako/image/176_pgi01_s.jpg" }
      let(:expected_pretty_filename) { "SHIROBAKOラジオBOX 第26回 4月6日放送.mp3" }
      let(:expected_can_download) { true }
      let(:expected_download_url) { "http://onsen.b-ch.com/radio/shirobako150406mE3h.mp3" }

      it_should_behave_like "Instance's methods"
      it_should_behave_like "Normal Instance's methods"
    end

    context "initialized by cannot_download_program1.xml" do
      let(:xml) {
        xml_path = Pathname.new(__dir__) + "../fixtures/cannot_download_program1.xml"
        Nokogiri.parse(xml_path.read).xpath("//program").first
      }

      let(:expected_id) { "noitamina" }
      let(:expected_original_xml_includes) { '<program id="noitamina">' }
      let(:expected_banner_image_url) { "http://www.onsen.ag/program/noitamina/image/15_pgi02_s.jpg" }
      let(:expected_can_download) { false }

      describe "#pretty_filename" do
        subject { -> { instance.pretty_filename } }
        it { expect(subject).to raise_error Ronsen::NotActiveProramError }
      end

      describe "#download" do
        subject { -> { instance.download } }
        it { expect(subject).to raise_error Ronsen::NotActiveProramError }
      end

      it_should_behave_like "Instance's methods"
    end

  end
end
