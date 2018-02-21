require 'hashugar'

module ContenidoHelpers
  def self.included(klass)
    models = %w(article category page author)
    models.push 'question' unless ENV['REBUILD_QUESTIONS'] == 'false'
    entry_models = (models - %w(article category))

    # Make models available inside config file
    define_method(:models) { models }

    # Dynamically generate entry access methods
    # e.g. page_entries, author_entries and so on
    entry_models.each do |model|
      method_name   = "#{model}_entries"
      variable_name = "@#{method_name}"

      define_method(method_name) do
        return unless content && content[model]
        return instance_variable_get(variable_name) if instance_variable_defined?(variable_name)
        instance_variable_set variable_name, content[model].map { |m| m[1].to_hashugar }
      end
    end
  end

  def categories
    category_entries ? category_entries.select(&:is_active) : []
  end

  def articles
    article_entries ? article_entries.reject(&:is_offer) : []
  end

  def offers
    article_entries ? article_entries.select(&:is_offer) : []
  end

  def questions
    question_entries || []
  end

  def question_groups
    @question_groups ||= category_entries.each_with_object({}) do |category, memo|
      memo[category.title] = questions.select { |question| question.categories.map(&:id).include?(category.id) }
      memo
    end
  end

  def pages
    page_entries || []
  end

  def default_author
    @default_author ||= author_entries ? author_entries.select(&:is_default).first : nil
  end

  def article_author(article)
    if article.author && author_entries.map(&:id).include?(article.author.id)
      article.author
    else
      default_author
    end
  end

  def article_path(article, category = nil, entry_type = :article)
    category    = article.categories.first unless category
    entry_point = entry_type.eql?(:article) ? "articulos" : "ofertas"

    "/#{entry_point}/#{category.title.downcase}/#{article.slug}.html"
  end

  def category_links(categories)
    categories.select { |category| category.try(:is_active) }.map { |category| link_to(category.title, "/#{category.title.downcase}").html_safe }.join(", ")
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
      articles.select { |a| a.tags }.select { |a| (a.tags & article_tags).any? }
    elsif article_categories.any?
      # Fetch articles with categories similar to the current article categories
      articles.select { |a| (a.categories.map(&:id) & article_categories.map(&:id)).any? }
    end

    filter_related(article, related, limit) if related.any?
  end

  private

  def content
    data_directory = if @app.data[:contenido].nil? || ENV["DATA_DIR"].eql?('sample')
      :sample
    else
      :contenido
    end
    @content ||= @app.data[data_directory]
  end

  def article_entries
    @article_entries ||= if content && content.article
      structurize(content.article)
        .sort_by(&:date)
        .reverse
    end
  end

  def category_entries
    @category_entries ||= structurize(content.category) if content && content.category
  end

  def structurize(collection)
    collection.map { |c| c[1].merge(
      slug:        c[1][:title].parameterize,
      legacy_slug: c[1][:title].downcase
    ).to_hashugar}
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
