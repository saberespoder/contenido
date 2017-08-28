require 'spec_helper'

describe 'article', type: :feature do
  before do
    visit '/finanzas'
  end

  context 'any article' do
    before do
      click_link('Campaña de Momentos: Consejo para padres con hijas entre 8 y 10 años')
    end

    it 'has a title' do
      expect(page).to have_selector('h1')
      expect(page.find('h1')).to have_content('Campaña de Momentos: Consejo para padres con hijas entre 8 y 10 años')
    end

    it 'has related articles block' do
      expect(page).to have_selector('.placeholder')
      expect(page.find('.placeholder')).to have_content('Contenido Relacionado')
    end

    it 'has links to parent categories' do
      categories = page.find('.article__categories')
      expect(categories.find_all('a').length).to eq(2)
      expect(categories).to have_content('Salud')
      expect(categories).to have_content('Finanzas')
    end
  end

  context 'an article with inactive categories' do
    before do
      click_link('El top 6 del Q&A')
    end

    it 'has only active categories' do
      categories = page.find('.article__categories')
      expect(categories.find_all('a').length).to eq(4)
      expect(categories).not_to have_content('Trabajo')
      expect(categories).not_to have_content('Noticias')
    end
  end

  context 'questions widget state' do
    it 'does not displayed if defined to false' do
      click_link('Campaña de Momentos: Consejo para padres con hijas entre 8 y 10 años')
      expect(page).not_to have_selector('#sep-widget')
    end
    it 'displayed if defined to true' do
      click_link('El top 6 del Q&A')
      expect(page).to have_selector('#sep-widget')
    end
    it 'displayed if not defined' do
      click_link('Aprenda inglés fácilmente desde su teléfono móvil')
      expect(page).to have_selector('#sep-widget')
    end
  end
end
