require 'spec_helper'

describe Ronsen::Accessor do
  let(:accessor) { Ronsen::Accessor.instance }
  context "with Internet access" do
    before do
      WebMock.allow_net_connect!
    end

    it 'can get soreppoi xml' do
      response = accessor.get_programs_xml
      expect(response.scan("<title>").count).to be > 10
      expect(response.scan(/\<movie_url\>http.+\/.+\.\w+\<\/movie_url\>/).count).to be > 10
    end

    after do
      WebMock.disable_net_connect!
    end

  end

  context "with mock" do

    describe "#get_programs_xml" do
      let(:xml) {
        xml_path = Pathname.new(__dir__) + "../fixtures/programs.xml"
        xml_path.read
      }

      let(:url) {
        Ronsen::Accessor::ONSEN_HOST + Ronsen::Accessor::PROGRAMS_XML_PATH
      }

      context "Success" do
        it "sends request with defined UserAgent" do
          ua = "Mozilla/////////xxxxxy[]"

          accessor.user_agent = ua

          stub = stub_request(:get, url)
            .with(:headers => { 'User-Agent' => ua })
            .to_return(status: 200, body: xml)

          accessor.get_programs_xml

          expect(stub).to have_been_requested
        end
      end


      context "Error" do
        subject { ->{ accessor.get_programs_xml } }
        it "throws ConnectionError when timeout" do
          stub_request(:get, url).to_timeout
          expect(subject).to raise_error(Ronsen::ConnectionError) {|e|
            expect(e.inner_exception).to be_a Faraday::TimeoutError
          }

        end

        it "throws ResponseError when response code is not 200" do
          status_code = 403
          stub_request(:get, url).to_return(status: status_code)
          expect(subject).to raise_error(Ronsen::ResponseError) {|e|
            expect(e.response.status).to eq status_code
          }
        end

      end
    end

    describe "#get_bin" do
      let(:url) { "http://mock.example.com/sample.mp3" }

      context "Success" do
        subject { accessor.get_bin(url) }

        shared_examples_for "normal" do

          it "sends request with defined UserAgent" do
            ua = "Mozilla/////////xxxxxy[]"

            accessor.user_agent = ua

            stub = stub_request(:get, url)
              .with(:headers => { 'User-Agent' => ua })
              .to_return(status: 200, body: file_path)

            subject

            expect(stub).to have_been_requested
          end

          it "returns Tempfile" do
            stub_request(:get, url)
              .to_return(status: 200, body: File.read(file_path))
            is_expected.to be_a Tempfile
          end

          it "fetches correct file" do
            expected_hash = Digest::SHA1.hexdigest(File.read(file_path))

            stub_request(:get, url)
              .to_return(status: 200, body: File.read(file_path))

            actual_hash = Digest::SHA1.hexdigest(subject.read)
            expect(actual_hash).to eq expected_hash
          end
        end

        context "small_file" do
          let(:file_path) { (Pathname.new(__dir__) + "../fixtures/small_file.jpg").to_s }

          it_should_behave_like "normal"
        end

        context "large_file" do
          let(:file_path) { (Pathname.new(__dir__) + "../fixtures/large_file.mp3").to_s }

          it_should_behave_like "normal"
        end
      end
    end
  end
end
