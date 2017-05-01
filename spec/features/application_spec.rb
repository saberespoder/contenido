require "spec_helper"

describe "application layout", type: :feature do
  before do
    visit "/"
  end

  it "has active categories in header" do
    expect(page).to have_selector "nav.header-nav"
    within "nav.header-nav" do
      expect(page).to have_content /All/i
      expect(page).to have_content /Finanzas/i
      expect(page).to have_content /Educación/i
      expect(page).to have_content /Salud/i
      expect(page).to have_content /Inmigración/i
    end
  end
end
