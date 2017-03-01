module BlogHelpers
  def blog_categories
    blog.articles.map { |a| article_categories a }.flatten.uniq
  end

  def article_categories(article)
    article.metadata[:page][:category]
  end

  def article_image(article)
    article.metadata[:page][:image]
  end

  def related_articles(article, limit = 3)
    blog_tags    = blog.tags
    article_tags = article.tags

    # @TODO: Use article categories if none of tags were defined in the system

    if blog_tags.any? && article_tags.any?
      # Fetch articles with tags similar to the current article tags
      article_tags.map { |t|
        blog_tags[t]
      # Unfileter current article
      }.flatten.uniq.reject { |a|
        a == article
      # Randomize and limit
      }.shuffle.take(limit)
    end
  end
end
