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

    def banner_image_url
      (URI.parse("http://www.onsen.ag/") +
       @xml.css("banner_image").first.text).to_s
    end

    def download
      target = @xml.css("program > movie_url").first.text
      Accessor.instance.get_bin(target)
    end

    def pretty_filename
      h = as_hash
      date = Date.parse h["up_date"]
      ext = File.extname h["movie_url"]
      "#{h["title"]} 第#{h["program_number"].rjust(2,"0")}回 #{date.month}月#{date.day}日放送#{ext}"
    end

    private
    def write_mp3_tag(mp3_file)

    end
  end
end
