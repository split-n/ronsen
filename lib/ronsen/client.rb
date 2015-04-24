module Ronsen
  class Client
    def get_programs
      Proram.parse_entire_xml(accessor.get_programs_xml)
    end

    def user_agent=(str)
      @accessor.user_agent = str
    end

    private
    def accessor
      @accessor ||= Accessor.new
    end
  end
end
