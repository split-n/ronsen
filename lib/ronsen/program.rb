module Ronsen
  class Program
    class << self
      def parse_entire_xml(xml_str,accessor)
        doc = Nokogiri.parse(xml_str)
        progs = doc.css("program").map{|p| self.new(p,accessor)}
        raise ResponseParseError if progs.empty?
        progs
      end
    end

    def initialize(prog_xml,accessor)
      raise ResponseParseError, "type is not Nokogiri::XML::Node" unless prog_xml.is_a? Nokogiri::XML::Node
      raise ResponseParseError, "root node is not program" if prog_xml.name != "program"
      @xml = prog_xml
      @accessor = accessor
    end

    def id
      @xml.attr("id")
    end

    def original_xml
      @xml.to_s
    end

    def as_hash
      h = Hash.from_xml(@xml.to_s)["program"]
      h = map_nil_to_empty_string(h)
      if h["personalities"]["personality"].is_a? Hash
        h["personalities"]["personality"] = [h["personalities"]["personality"]]
      end
      h
    end

    def banner_image_url
      (URI.parse("http://www.onsen.ag/") +
       @xml.css("banner_image").first.text).to_s
    end

    def can_download?
      !@xml.css("movie_url").first.text.empty?
    end

    def download
      raise NotActiveProramError if !can_download?
      target = @xml.css("movie_url").first.text
      @accessor.get_bin(target)
    end

    def pretty_filename
      raise NotActiveProramError if !can_download?
      h = as_hash
      date = Date.parse h["up_date"]
      ext = File.extname h["movie_url"]
      "#{h["title"]} 第#{h["program_number"].rjust(2,"0")}回 #{date.month}月#{date.day}日放送#{ext}"
    end


    private
    def map_nil_to_empty_string(hash)
      hash.map{|k,v|
        [k, (case v
        when nil
          ""
        when Hash
          map_nil_to_empty_string(v)
        else
          v
        end)
        ]
      }.to_h
    end

    def write_mp3_tag(mp3_file_path)
      h = as_hash
      banner_file = download_banner
      Mp3Info.open(mp3_file_path) do |mp3|
        mp3.tag2.remove_pictures
        mp3.removetag1
        mp3.removetag2
        mp3.tag2["TIT2"] = "#{h["title"]} 第#{h["program_number"]}回"
        mp3.tag2["TPE1"] = h["actor_tag"]
        mp3.tag2["TALB"] = h["title"]
        mp3.tag2["TYER"] = Date.parse(h["up_date"]).year
        mp3.tag2["TRCK"] = h["program_number"]
        mp3.tag2["TCON"] = "Radio"
        mp3.tag2["TRSN"] = "Onsen"
        mp3.tag2.add_picture(banner_file.read)
      end
      banner_file.close
    end

    def download_banner
      raise NotActiveProramError if !can_download?
      path = @xml.css("banner_image").first.text
      base = URI.parse(Accessor::ONSEN_HOST)
      @accessor.get_bin(base + path)
    end
  end
end
