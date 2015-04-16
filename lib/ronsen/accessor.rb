module Ronsen
  class Accessor
    ONSEN_HOST = "http://onsen.ag"
    def initialize
      @conns = {}
      @conns[ONSEN_HOST] = Faraday.new(url:ONSEN_HOST) {|f|
        f.request :url_encoded
        f.adapter Faraday.default_adapter
      }
    end

    def get_xml(week_no)
      code = (Time.now.to_f*1000).to_i.to_s
      file_name = "regular_#{week_no}"

      res = @conns[ONSEN_HOST].post("/getXML.php",{code:code, file_name:file_name})
      if res.status != 200
        raise
      end
      res.body
    end

    def get_bin(url)

    end

  end
end
