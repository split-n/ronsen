module Ronsen
  class Client
    def initialize
      @accessor = Accessor.new
    end

    def get_programs
      Program.parse_entire_xml(@accessor.get_programs_xml,@accessor)
    end

    def user_agent=(str)
      @accessor.user_agent = str
    end
  end
end
