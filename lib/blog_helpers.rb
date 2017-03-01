module BlogHelpers
  def article_categories
    blog.articles.map { |a| a.metadata[:page][:category] }
  end
end
