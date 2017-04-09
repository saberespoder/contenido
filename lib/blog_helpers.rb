module BlogHelpers
  def categories
    sepcontent && sepcontent.categories ? structurize(sepcontent.categories).select { |c| c.isActive } : []
  end

  def articles
    sepcontent && sepcontent.articles ? structurize(sepcontent.articles).sort_by(&:date).reverse : []
  end

  def article_path(article, category = nil)
    category = article.categories.first unless category
    "/articulos/#{category.title}/#{article.slug}.html"
  end

  def previous_page(slicer)
    page = current_page_index(slicer)
    @previous_page ||= "#{slicer[:pattern]}/#{page}" if page && page != 0
  end

  def next_page(slicer)
    page = current_page_index(slicer)
    last = slicer[:collection].index(slicer[:collection].last)
    @next_page ||= "#{slicer[:pattern]}/#{page+2}" if page && page != last
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
    @sepcontent ||= @app.data.sepcontent if @app.data[:sepcontent]
  end

  def structurize(collection)
    collection.map { |c| OpenStruct.new(c[1].merge(
      slug: c[1][:title].parameterize,
      legacy_slug: c[1][:title].downcase
    ))}
  end

  def collection_slice(collection, per_page = ENV["ARTICLES_PER_PAGE"].to_i)
    collection.each_slice(per_page).to_a
  end

  def slicer_attributes(collection, slice, pattern = "/articulos/pages")
    Hash[
      slicer: {
        collection: collection,
        slice: slice,
        pattern: pattern
      }
    ]
  end

  def current_page_index(slicer)
    slicer[:collection].index(slicer[:slice])
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
