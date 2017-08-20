require "spec_helper"

describe "category", type: :feature do
  before do
    visit "/"
    click_link("Finanzas")
  end

  it "has the correct category headline" do
    expect(page).to have_selector "h1"
    within "h1" do
      expect(page).to have_content /Finanzas/i
    end
  end

  # @TODO: It would be great to share this part with index spec

  it "has a defined number of articles per page" do
    articles = page.find_all(".articles-item")
    expect(articles.size).to eq(ENV["ARTICLES_PER_PAGE"].to_i)
  end

  it "has advert block" do
    expect(page).to have_selector ".placeholder--partner"
  end

  it "has pagination" do
    expect(page).to have_selector ".pager"
    within ".pager" do
      expect(page).to have_content /Página siguiente/i
      click_link("Página siguiente")
    end

    expect(page).to have_selector ".pager"
    within ".pager" do
      expect(page).to have_content /Página anterior/i
    end
  end
end
