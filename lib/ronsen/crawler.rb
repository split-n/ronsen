module Ronsen
  class Crawler

    def initialize
      @conn = Faraday.new(url:"http://onsen.ag/") {|f|
        f.request :url_encoded
        f.adapter Faraday.default_adapter
      }
    end
    def get_xml(week_no)
      code = (Time.now.to_f*1000).to_i.to_s
      file_name = "regular_#{week_no}"

      res = @conn.post("/getXML.php",{code:code, file_name:file_name})
      if res.status != 200
        raise
      end
    end

    def split_xml_per_program(xml_str)
      doc = Nokogiri.parse(xml)
      doc.css("program").to_a
    end

    def parse_program(program_xml)

    end

  end
end
