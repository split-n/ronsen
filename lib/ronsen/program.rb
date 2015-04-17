module Ronsen
  class Program
    class << self
      def parse_entire_xml(xml_str)
        doc = Nokogiri.parse(xml_str)
        doc.css("program").map{|p| self.new(p)}
      end
    end

    def initialize(prog_xml)
      @xml = prog_xml
    end

    def id
      @xml.attr("id").text
    end

    def original_xml
      @xml.to_s
    end

    def as_hash
    end

    def download
      target = @xml.css("program > movie_url").first.text
      Accessor.instance.get_bin(target)
    end

  end
end
