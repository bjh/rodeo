require 'bundler/gem_tasks'
require 'nokogiri'

task :test do
  url = "http://studeo.s3.amazonaws.com/BronzeC/BronzeC_p1.html"
  html = Nokogiri::HTML(open(url))

  puts html.css('meta[name="template"]').first['content']
  # puts html
end


task :test2 do
  begin
    url = "http://studeo.s3.amazonaws.com/BronzeD_love/template"
    file = open(url).read
    puts file
  rescue OpenURI::HTTPError => e
    puts e.message
  end
end
