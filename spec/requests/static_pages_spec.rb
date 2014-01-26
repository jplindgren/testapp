require 'spec_helper'

#do not forget to add in spec_helper the capybara DSL
describe "Static pages" do

  let(:base_title) { 'MicroTwitter ' } 
  subject { page }

  describe "Home Page" do
    before { visit root_path }

    it { should have_content('Welcome to the MicroTwitter') }
    it { should have_title("#{base_title}")}
  end

  describe "Help page" do
    before { visit help_path }

    it { should have_content('Help') }
    it { should have_title("#{base_title} | Help") }
  end

  describe "About page" do
    before { visit about_path }

    it { should have_content 'About Us'}
    it { should have_title "#{base_title} | About us" }
  end

  describe "Contact page" do
    before { visit contact_path }

    it { should have_content 'Contact' }
    it { should have_title "#{base_title} | Contact" }
  end
end
