xml.instruct!
xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do
  xml.title "自由风暴"
  xml.subtitle "自由风暴"
  xml.id "http://freestorm.org/"
  xml.link "href" => "http://freestorm.org/"
  xml.link "href" => "http://freestorm.org/feed.xml", "rel" => "self"
  xml.updated blog('cn').articles.first.date.to_time.iso8601
  xml.author { xml.name "自由风暴" }

  blog('cn').articles[0..5].each do |article|
    xml.entry do
      xml.title article.title
      xml.link "rel" => "alternate", "href" => article.url
      xml.id article.url
      xml.published article.date.to_time.iso8601
      xml.updated article.date.to_time.iso8601
      xml.author { xml.name (article.data.author || "自由风暴") }
      xml.summary article.summary, "type" => "html"
      xml.content article.body, "type" => "html"
    end
  end
end
