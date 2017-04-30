require "spec_helper"

describe "article", type: :feature do
  before do
    visit "/finanzas"
  end

  context "any article" do
    before do
      click_link("Campaña de Momentos: Consejo para padres con hijas entre 8 y 10 años")
    end

    it "has a title" do
      expect(page).to have_selector("h1")
      expect(page.find("h1")).to have_content("Campaña de Momentos: Consejo para padres con hijas entre 8 y 10 años")
    end

    it "has related articles blck" do
      expect(page).to have_selector(".related")
      expect(page.find(".related")).to have_content("Related articles")
    end
  end
end
