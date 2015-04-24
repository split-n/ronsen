require 'nokogiri'
require 'faraday'
require 'singleton'
require 'open-uri'
require 'active_support/core_ext/hash/conversions'
require 'mp3info'
require "digest/sha1"

require "ronsen/version"
require "ronsen/errors"
require "ronsen/accessor"
require "ronsen/program"
require "ronsen/client"

ActiveSupport::XmlMini.backend = 'Nokogiri'


module Ronsen

end
