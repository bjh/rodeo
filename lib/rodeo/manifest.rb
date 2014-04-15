require 'nokogiri'
require 'open-uri'
require 'json'
require 'aws-sdk'

module Rodeo
  # manage the data/content of the page as JSON
  class Manifest
    attr_accessor :base_url, :html, :manifest

    def initialize
      @base_url = 'http://studeo.s3.amazonaws.com/'
      @html = nil
      @manifest = {}
    end

    def load(brochure, page)
      json = open(path(brochure, page)).read
      self.manifest = JSON.parse(json)
    end

    def get(brochure, page)
      AWS.config(
        access_key_id: Rodeo.access_key_id,
        secret_access_key: Rodeo.secret_access_key)

      name = "#{brochure}/#{brochure}_p#{page}.json"
      s3 = AWS::S3.new
      obj = s3.buckets[Rodeo.bucket].objects[name]
      puts obj.read
    end

    def save(brochure, page)
      JSON.generate(manifest)
    end

    def parse(brochure, page)
      url = "#{base_url}#{brochure}/#{brochure}_p#{page}.html"
      self.html = Nokogiri::HTML(open(url))

      images()
    end

  private

    def path(brochure, page)
      "#{base_url}#{brochure}/#{brochure}_p#{page}.json"
    end

    def m(key)
      @manifest[key] = @manifest.fetch(key, {})
      @manifest[key]
    end

    def images
      html.css('img').each do |image|
        id = image.parent.attr('id')
        m(:images)[id.to_sym] = image[:src]
      end
    end
  end
end
