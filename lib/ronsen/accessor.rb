module Ronsen
  class Accessor
    ONSEN_HOST = "http://onsen.ag"

    def initialize
      @conns = {}
    end

    def get_programs_xml
      conn = Faraday.new(url:ONSEN_HOST) {|f|
        f.request :url_encoded
        f.adapter Faraday.default_adapter
      }

      res = conn.get("/app/programs.xml")
      if res.status != 200 || res.body.empty?
        raise
      end
      res.body
    end

    def get_bin(url)

    end

  end
end
