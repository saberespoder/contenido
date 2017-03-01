module BlogHelpers
  def blog_categories
    @blog_categories ||= Hash[article_categories.sort]
  end

  def image_url(article)
    article.data[:image]
  end

  def category_path(category)
    "/categories/#{category.parameterize}.html"
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

  private

  def categories(article)
    category_array(article.data[:categories])
  end

  def category_array(categories)
    (categories || "Uncategorized").split(/,\s*/)
  end

  def article_categories
    Hash.new { [] }.tap do |c|
      blog.articles.each do |a|
        categories(a).each do |ac|
          c[ac] <<= a
        end
      end
    end
  end
end
