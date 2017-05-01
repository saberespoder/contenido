require "spec_helper"

describe "index", type: :feature do
  before do
    visit "/"
  end

  it "has the correct default headline" do
    expect(page).to have_selector "h1"
    within "h1" do
      expect(page).to have_content /Elija su ruta al conocimiento/i
    end
  end
end
