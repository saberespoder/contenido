module BlogHelpers
  def categories
    structurize sepcontent.categories
  end

  def articles
    structurize sepcontent.articles
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

  def sepcontent
    @sepcontent ||= @app.data.sepcontent
  end

  def structurize(collection)
    collection.map { |c| OpenStruct.new(c[1].merge(slug: c[1][:title].parameterize)) }
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
