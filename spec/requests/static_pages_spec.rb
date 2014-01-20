require 'spec_helper'

#do not forget to add in spec_helper the capybara DSL
describe "Static pages" do

  describe "Home Page" do
    it "should have content 'Sample App'" do
      visit '/static_pages/home'
      expect(page).to have_content('Sample App')
    end

    it "should have the right title"
	  expect(page).to have_title("MicroTwitter | Home")
	end
  end

  describe "Help page" do
    it "should have content 'Help'" do
      visit '/static_pages/help'
      expect(page).to have_content('Help')
    end

    it "should have the right title"
	  expect(page).to have_title("MicroTwitter | Help")
	end
  end

  describe "About page" do
    it "should have content 'About Us'" do
      visit '/static_pages/about'
      expect(page).to have_content('About Us')
    end

    it "should have the right title"
	  expect(page).to have_title("MicroTwitter | About us")
	end
  end
end
