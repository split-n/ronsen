module Ronsen
  class Client
    def get_programs
      Proram.parse_entire_xml(accessor.get_programs_xml)
    end


    private
    def accessor
      Accessor.instance
    end
  end
end
