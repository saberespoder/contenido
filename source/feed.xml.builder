xml.instruct!
xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do
  site_url = config[:content_url]
  content = defined?(category_articles) ? category_articles : articles

  xml.title    config[:content_title]
  xml.subtitle config[:content_subtitle]
  xml.id URI.join(site_url)
  xml.link "href" => URI.join(site_url)
  xml.updated(content.first.date.to_time.iso8601) if content.any?
  #xml.author { xml.name "Blog Author" }

  content[0..config[:feed_articles]].each do |article|
    xml.entry do
      xml.title article.title
      xml.link rel: :alternate, href: "#{site_url}#{article_path(article)}"
      xml.id "#{site_url}#{article_path(article)}"
      xml.published article.date.to_time.iso8601
      xml.updated article.date.to_time.iso8601
      #xml.author { xml.name "Article Author" }
      xml.link rel: :enclosure, type: "image/jpeg", href: article.image.url.gsub(%r{^//}, "https://") if article.image
      xml.summary truncate(strip_tags(article.body), length: 250)
      xml.content Markdown.new(strip_tags(article.body)).to_html, type: :html
    end
  end
end
