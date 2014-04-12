require 'spec_helper'


describe "Micropost pages" do
  
  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "micropost creation" do
  	before { visit root_path }

  	describe "with invalid information" do
  		it "should not create micropost" do
  			expect { click_button "Post" }.not_to change(Micropost, :count)
  		end

  		describe "error messages" do
  			before { click_button 'Post' }
  			it { should have_content 'error' }
  		end
  	end

  	describe "with valid information" do
  		before { fill_in "micropost_content", with: "Lorem ipsum" }
  		it "should create micropost" do
  			expect{ click_button 'Post' }.to change(Micropost, :count).by(1)
  		end
  	end
  end

  describe "micropost destruction" do
    before { FactoryGirl.create(:micropost, user: user) }

    describe "as correct user" do
      before { visit root_path }
      it "should delete a micropost" do
        expect { click_link "delete" }.to change(Micropost, :count).by(-1)
      end
    end
  end


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
