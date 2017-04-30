module BlogHelpers
  def categories
    category_entries ? category_entries.select(&:is_active) : []
  end

  def articles
    article_entries ? article_entries.reject(&:is_offer) : []
  end

  def offers
    article_entries ? article_entries.select(&:is_offer) : []
  end

  def article_path(article, category = nil, entry_type = :article)
    category    = article.categories.first unless category
    entry_point = entry_type.eql?(:article) ? "articulos" : "ofertas"

    "/#{entry_point}/#{category.title.downcase}/#{article.slug}.html"
  end

  def category_links(categories)
    categories.select(&:is_active).map { |category| link_to(category.title, "/#{category.title.downcase}").html_safe }.join(", ")
  end

  def previous_page(slicer)
    page = current_page_index(slicer)
    last = slicer[:collection].index(slicer[:collection].last)

    @previous_page ||= "#{slicer[:pattern]}/#{page+2}" if page && page != last
  end

  def next_page(slicer)
    page = current_page_index(slicer)
    @next_page ||= "#{slicer[:pattern]}/#{page}" if page && page != 0
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
    data_directory = if @app.data[:sepcontent].nil? || ENV["DATA_DIR"].eql?("sample")
      :sample
    else
      :sepcontent
    end
    @sepcontent ||= @app.data[data_directory]
  end

  def article_entries
    if sepcontent && sepcontent.articles
      structurize(sepcontent.articles)
        .sort_by(&:date)
        .reverse
    end
  end

  def category_entries
    structurize(sepcontent.categories) if sepcontent && sepcontent.categories
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
