require 'nokogiri'
require 'faraday'
require 'singleton'
require 'open-uri'
require 'active_support/core_ext/hash/conversions'
require 'mp3info'
require "digest/sha1"

require "ronsen/version"
require "ronsen/accessor"
require "ronsen/client"
require "ronsen/program"
require "ronsen/errors"

ActiveSupport::XmlMini.backend = 'Nokogiri'


module Ronsen

end
