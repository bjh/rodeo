require 'nokogiri'
require 'open-uri'
require 'json'
require 'aws-sdk'

module Rodeo
  # manage the data/content of the page as JSON
  class Manifest
    attr_accessor :manifest, :brochure, :page, :s3

    def initialize(brochure, page)
      @brochure = brochure
      @page = page
      @html = nil
      @manifest = {}

      setup_aws()
    end

    def generate
      images(Nokogiri::HTML(open(url)))
    end

    def load
      get_or_create()
    end

    def store
      json = JSON.generate(manifest)
      # puts "json to save: {json}"
      s3.buckets[Rodeo.bucket].objects[s3_path].write(json)
      s3.buckets[Rodeo.bucket].acl = :public_read
    end

  private

    def setup_aws
      AWS.config(
        access_key_id: Rodeo.access_key_id,
        secret_access_key: Rodeo.secret_access_key)

      self.s3 = AWS::S3.new
      s3.buckets[Rodeo.bucket].acl = :public_read
    end

    def get_or_create
      file = s3.buckets[Rodeo.bucket].objects[s3_path]

      if file.exists?
        self.manifest = JSON.parse(file.read)
      else
        self.manifest = {}
      end
    end

  private

    def url
      "#{Rodeo.base_url}#{brochure}/#{brochure}_p#{page}.html"
    end

    def s3_path
      "#{brochure}/#{brochure}_p#{page}.json"
    end

    def m(key)
      @manifest[key] = @manifest.fetch(key, {})
      @manifest[key]
    end

    def images(html)
      html.css('img').each do |image|
        id = image.parent.attr('id')
        m(:images)[id.to_sym] = image[:src]
      end
    end
  end
end
