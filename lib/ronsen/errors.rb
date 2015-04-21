module Ronsen
  class Error < RuntimeError; end
  class ConnectionError < Error
    attr_reader :inner_exception
    def initialize(ex)
      super(ex.message)
      @inner_exception = ex
    end
  end

  class ResponseError < StandardError
    attr_reader :content
    def initialize(content)
      super(content)
      @content = content
    end
  end
end
