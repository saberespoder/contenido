module BlogHelpers
  def article_categories
    blog.articles.map { |a| a.metadata[:page][:category] }
  end

  def related_articles(article, limit = 3)
    blog_tags    = blog.tags
    article_tags = article.tags

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
