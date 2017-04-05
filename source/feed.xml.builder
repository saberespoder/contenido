xml.instruct!
xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do
  site_url = config[:platform_url]

  xml.title    config[:platform_title]
  xml.subtitle config[:platform_subtitle]
  xml.id URI.join(site_url)
  xml.link "href" => URI.join(site_url)
  xml.updated(articles.first.date.to_time.iso8601) if articles.any?
  #xml.author { xml.name "Blog Author" }

  articles[0..config[:feed_articles]].each do |article|
    xml.entry do
      xml.title article.title
      xml.link "rel" => "alternate", "href" => URI.join(site_url, article_path(article))
      xml.id URI.join(site_url, article_path(article))
      xml.published article.date.to_time.iso8601
      xml.updated article.date.to_time.iso8601
      #xml.author { xml.name "Article Author" }
      if article.image
        xml.link rel:  'enclosure',
                 type: 'image/jpeg',
                 href: article.image.url.gsub(%r{^//}, 'https://')
      end
      xml.summary truncate(strip_tags(article.body), length: 250)
      xml.content Markdown.new(strip_tags(article.body)).to_html
    end
  end
end
