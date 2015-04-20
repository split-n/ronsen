require 'spec_helper'

describe Ronsen::Accessor do
  context "with Internet access" do
    before do
      WebMock.allow_net_connect!
    end

    it 'can get soreppoi xml' do
      accessor = Ronsen::Accessor.instance
      response = accessor.get_programs_xml
      expect(response.scan("<title>").count).to be > 10
      expect(response.scan(/\<movie_url\>http.+\/.+\.\w+\<\/movie_url\>/).count).to be > 10
    end

    after do
      WebMock.disable_net_connect!
    end

  end

  describe "#get_programs_xml" do
    let(:xml) {
      xml_path = Pathname.new(__dir__) + "../fixtures/programs.xml"
      xml_path.read
    }

    it "sends request with defined UserAgent" do
      ua = "Mozilla/////////xxxxxy[]"
      url = Ronsen::Accessor::ONSEN_HOST +
        Ronsen::Accessor::PROGRAMS_XML_PATH

      target = Ronsen::Accessor.instance
      target.user_agent = ua

      stub = stub_request(:get, url)
        .with(:headers => { 'User-Agent' => ua })
        .to_return(status: 200, body: xml)

      target.get_programs_xml

      expect(stub).to have_been_requested
    end
  end
end
