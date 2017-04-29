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
end
