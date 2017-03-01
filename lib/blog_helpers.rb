module BlogHelpers
  def blog_categories
    @blog_categories ||= Hash[system_categories.sort]
  end

  def image_url(article)
    article.data[:image]
  end

  def category_path(category)
    "/categories/#{category.parameterize}.html"
  end

  def related_articles(article, limit = 3)
    article_tags       = article.tags
    article_categories = article_categories(article)

    related = if article_tags.any?
      # Fetch articles with tags similar to the current article tags
       article_tags.map { |t| blog.tags[t] }
    elsif article_categories.any?
      # Fetch articles with categories similar to the current article tags
      blog.articles.select { |a| (article_categories(a) & article_categories(article)).any? }
    end

    filter_related(article, related, limit) if related.any?
  end

  private

  def article_categories(article)
    category_array(article.data[:categories])
  end

  def category_array(categories)
    (categories || "Uncategorized").split(/,\s*/)
  end

  def system_categories
    Hash.new { [] }.tap do |c|
      blog.articles.each do |a|
        article_categories(a).each do |ac|
          c[ac] <<= a
        end
      end
    end
  end

  def filter_related(article, collection, limit)
    collection
      .flatten
      .uniq
      .reject { |a| a == article }
      .shuffle
      .take(limit)
  end
end
