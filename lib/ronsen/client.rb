module Ronsen
  class Client
    def initialize(accessor=nil)
      @accessor = accessor || Accessor.new
    end

    def get_active_programs
      get_all_programs.select{|p| p.can_download?}
    end

    def get_all_programs
      Program.parse_entire_xml(@accessor.get_programs_xml,@accessor)
    end

    def user_agent=(str)
      @accessor.user_agent = str
    end
  end
end
