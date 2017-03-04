module BlogHelpers
  def categories
    structurize sepcontent.categories
  end

  def articles
    structurize sepcontent.articles
  end

  def related_articles(article, limit = 3)
    article_tags       = article.tags || []
    article_categories = article.categories

    related = if article_tags.any?
      # Fetch articles with tags similar to the current article tags
       article_tags.map { |t| blog.tags[t] }
    elsif article_categories.any?
      # Fetch articles with categories similar to the current article tags
      articles.select { |a| (a.categories.map(&:id) & article.categories.map(&:id)).any? }
    end

    filter_related(article, related, limit) if related.any?
  end

  private

  def sepcontent
    @sepcontent ||= @app.data.sepcontent
  end

  def collection_slice(collection)
    collection.each_slice(ENV["ARTICLES_PER_PAGE"].to_i)
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
