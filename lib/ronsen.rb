require 'nokogiri'
require 'faraday'
require 'singleton'
require 'open-uri'
require 'active_support/core_ext/hash/conversions'
require 'mp3info'

require "ronsen/version"
require "ronsen/accessor"
require "ronsen/crawler"
require "ronsen/program"
require "ronsen/errors"

ActiveSupport::XmlMini.backend = 'Nokogiri'


module Ronsen

end
