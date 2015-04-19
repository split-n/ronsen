module Ronsen
  class Crawler
    def initialize
      @accessor = Accessor.new
    end

    def split_xml_per_program(xml_str)
      doc = Nokogiri.parse(xml)
      doc.css("program").to_a
    end

    def parse_program(program_xml)

    end

    private
    def url_as_origin(url)


    end

  end
end
