require "spec_helper"

describe "article", type: :feature do
  before do
    visit "/finanzas"
  end

  context "any article" do
    before do
      visit("/articulos/finanzas/campana-de-momentos-consejo-para-padres-con-hijas-entre-8-y-10-anos")
    end

    it "has a title" do
      expect(page).to have_selector("h1")
      expect(page.find("h1")).to have_content("Campaña de Momentos: Consejo para padres con hijas entre 8 y 10 años")
    end

    it "has related articles block" do
      expect(page).to have_selector(".related")
      expect(page.find(".related")).to have_content("Related articles")
    end

    it "has links to parent categories" do
      categories = page.find(".article__categories")
      expect(categories.find_all("a").length).to eq(2)
      expect(categories).to have_content("Salud")
      expect(categories).to have_content("Finanzas")
    end
  end
end
