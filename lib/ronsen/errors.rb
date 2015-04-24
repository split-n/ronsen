module Ronsen
  class Error < RuntimeError; end
  class ConnectionError < Error
    attr_reader :inner_exception
    def initialize(ex=nil)
      if ex
        super(ex.message)
      else
        super()
      end
      @inner_exception = ex
    end
  end

  class ResponseError < Error
    attr_reader :content
    def initialize(content)
      super(content)
      @content = content
    end
  end

  class ResponseParseError < Error
    def initialize(msg=nil)
      super(msg)
    end
  end

  class NotActiveProramError < Error; end
end
