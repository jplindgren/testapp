require 'spec_helper'
require 'ruby-debug'

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

      it { should have_link('Users', href: users_path) }
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

  describe "authorization" do
    describe "for non-signed-in user" do
      let(:user) { FactoryGirl.create(:user) }

      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          fill_in "Email", with: user.email
          fill_in "Password", with: user.password
          click_button "Sign in"
        end

        describe "after signing in" do
          it "should render the desired protected page" do
            expect(page).to have_title('Edit user')
          end
        end
      end

      describe "in the Users controller" do

        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_title('Sign in') } #rails 4.0?
          #it { should have_selector('title', text: 'Sign in') }  #rails 3.2
        end

        describe "submitting to the update action" do
          before { put user_path(user) }
          specify { expect(response).to redirect_to(signin_path) }
        end       

        describe "visiting the index page" do
          before { visit users_path user }
          it { should have_title('Sign in') }
        end 
      end      
    end #for non-signed-in user

    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrongUser@gmail.com") }
      before { sign_in user, no_capybara: true }

      describe "submitting a GET request to the Users#edit action" do
        before { get edit_user_path(wrong_user) }
        specify { expect(response.body).not_to match(full_title('Edit user')) }
        specify { expect(response).to redirect_to root_url }
      end

      describe "submitting a PUT request to the Users#update action" do
        before { put user_path(wrong_user) }
        specify { expect(response).to redirect_to root_url }
      end
    end

    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { sign_in non_admin }

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { response.should redirect_to(root_url) }
      end
    end
  end #authorization


  def sign_in(user, options = {})
    if options[:no_capybara]
      # Sign in when not using Capybara.
      remember_token = User.new_remember_token
      cookies[:remember_token] = remember_token
      user.update_attribute(:remember_token, User.encrypt(remember_token))
    else
      visit signin_path
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
      click_button "Sign in"
    end
  end
  
end 


