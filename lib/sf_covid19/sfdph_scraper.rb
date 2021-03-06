# frozen_string_literal: true

require 'rubygems'
require 'nokogiri'
require 'open-uri'

module SFCOVID19
  class SFDPHScraper
    SFDPH_URL = 'https://www.sfdph.org/dph/alerts/coronavirus.asp'

    def self.scrape!
      URI.open(SFDPH_URL) do |content|
        doc = Nokogiri::HTML(content)
        doc.css('div.box2 p').each_with_object({}) do |para, data|
          case para.text
          when /([^:]+):\s+(\d+)/i
            raw_key = Regexp.last_match(1)
            raw_value = Regexp.last_match(2)

            key = raw_key.to_s.chomp.downcase.gsub(/ /, '_')
            value = raw_value.to_i

            data[key] = value
          end
        end
      end
    end
  end
end
