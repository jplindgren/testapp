require 'spec_helper'

#do not forget to add in spec_helper the capybara DSL
describe "Static pages" do

  let(:base_title) { 'MicroTwitter' } 

  describe "Home Page" do
    it "should have content 'Sample App'" do
      visit '/static_pages/home'
      expect(page).to have_content('Sample App')
    end

    it "should have the right title" do
       visit '/static_pages/home'
	     expect(page).to have_title("#{base_title}")
	  end
  end

  describe "Help page" do
    it "should have content 'Help'" do
      visit '/static_pages/help'
      expect(page).to have_content('Help')
    end

    it "should have the right title" do
      visit '/static_pages/help'
      expect(page).to have_title("#{base_title} | Help")
	  end
  end

  describe "About page" do
    it "should have content 'About Us'" do
      visit '/static_pages/about'
      expect(page).to have_content('About Us')
    end

    it "should have the right title" do
      visit '/static_pages/about'
	    expect(page).to have_title("#{base_title} | About us")
    end
  end

  describe "Contact page" do
    it "Should have content 'Contact'" do
      visit '/static_pages/contact'
      expect(page).to have_content("Contact")
    end

    it "Should have the right title" do
      visit '/static_pages/contact'
      expect(page).to have_title("#{base_title} | Contact")
    end
  end
end