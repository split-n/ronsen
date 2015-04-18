module Ronsen
  class Program
    class << self
      def parse_entire_xml(xml_str)
        doc = Nokogiri.parse(xml_str)
        progs = doc.css("program").map{|p| self.new(p)}
        progs.empty? ? raise : progs
      end
    end

    def initialize(prog_xml)
      raise "type is not Nokogiri::XML::Node" unless prog_xml.is_a? Nokogiri::XML::Node
      raise "root node is not program" if prog_xml.name != "program"
      @xml = prog_xml
    end

    def id
      @xml.attr("id")
    end

    def original_xml
      @xml.to_s
    end

    def as_hash
      h = Hash.from_xml(@xml.to_s)
      h["program"]
    end

    def download
      target = @xml.css("program > movie_url").first.text
      Accessor.instance.get_bin(target)
    end

  end
end
