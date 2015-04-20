module Ronsen
  class Accessor
    include Singleton
    ONSEN_HOST = "http://www.onsen.ag"
    PROGRAMS_XML_PATH = "/app/programs.xml"

    attr_accessor :user_agent

    def initialize
      @user_agent = 'Dalvik/1.6.0 (Linux; U; Android 4.4.2), like Ronsen gem';
    end

    def get_programs_xml
      conn = Faraday.new(url:ONSEN_HOST) {|f|
        f.request :url_encoded
        f.adapter Faraday.default_adapter
      }
      conn.headers[:user_agent] = @user_agent

      begin
        res = conn.get(PROGRAMS_XML_PATH)
      rescue => e
        raise ConnectionError, e
      end
        if res.status != 200 || res.body.empty?
          raise ResponseError, res
        end

      res.body
    end

    def get_bin(url)
      file = open(url)
      if file.status.first != "200"
        raise
      end
      file
    end
  end
end
