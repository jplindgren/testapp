require 'spec_helper'

describe "Authentication" do
  subject { page }

  describe "signin" do
  	before { visit signin_path }	
	
	  it { should have_content('Sign in') }
	
  	describe "with invalid information" do
    		before { click_button "Sign in" }
    		
    		it { should have_title('Sign in') }
  		  it { should have_selector('div.alert.alert-error') }  

        describe "after visiting another page" do
          before { visit root_path }
          it { should_not have_selector('div.alert.alert-error') }
        end
  	end

  	describe "with valid information" do
  		let(:user) { FactoryGirl.create(:user) }
  		before { sign_in user }

  		it { should have_link('Profile', href: user_path(user)) }
  		it { should have_link('Sign out', href: signout_path) }
      it { should have_link('Settings',  href: edit_user_path(user)) }
  		it { should_not have_link('Sign in', href: signin_path) }

      describe "followed by sign out" do
        before { click_link 'Sign out' }

        it { should have_link('Sign in') }
      end
  	end

  end #signin 

  def sign_in(user, options = {})
    if options[:no_capybara]
      # Sign in when not using Capybara.
      remember_token = User.new_remember_token
      cookies[:remember_token] = remember_token
      user.update_attribute(:remember_token, User.hash(remember_token))
    else
      visit signin_path
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
      click_button "Sign in"
    end
  end
end 


