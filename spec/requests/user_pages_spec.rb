require 'spec_helper'
require 'ruby-debug'

include ApplicationHelper

describe "User pages" do
	subject { page } 

  describe "index" do
    let(:user) { FactoryGirl.create(:user) }
    before(:each) do
      sign_in user
      visit users_path
    end

    it { should have_title('All users') }
    it { should have_selector('h1',  text: 'All users') }
    it { should have_submit_button("Search") }

    describe "pagination" do
      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all) { User.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each user" do
        User.paginate(page: 1).each do |user|
          expect(page).to have_selector('li', text: user.name)
        end
      end
    end

    describe "search" do
      let!(:user_search_1) { FactoryGirl.create(:user, name: "Joao Paulo") }
      let!(:user_search_2) { FactoryGirl.create(:user, name: "Joao") }
      let!(:user_search_3) { FactoryGirl.create(:user, name: "Aline") }
      let(:search_name) { "joao" } 

      before do
        fill_in "search", with: search_name
        click_button "Search"
      end

      it "should list found users" do
        expect(page).to have_selector('li', text: user_search_1.name)
        expect(page).to have_selector('li', text: user_search_2.name)
        expect(page).to_not have_selector('li', text: user_search_3.name)
      end
    end

    describe "delete links" do
      it { should_not have_link('delete') }

      describe "as admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit  users_path
        end

        it { should have_link('delete'), href: user_path(User.first) }
        it "should be able to delete another user" do
          expect { click_link('delete') }.to change(User, :count).by(-1)
        end
        it { should_not have_link('delete', href: user_path(admin)) }

      end
    end
  end #index

  describe "Profile page" do
  	let(:user) { FactoryGirl.create(:user) }
    let!(:micropost1) { FactoryGirl.create(:micropost, user: user, content: "foo") }
    let!(:micropost2) { FactoryGirl.create(:micropost, user: user, content: "bar") }

  	before { visit user_path(user) }
  	it { should have_content(user.name) }
  	it { should have_title(user.name) }

    describe "microposts" do
      it { should have_content(micropost1.content) }
      it { should have_content(micropost2.content) }
      it { should have_content(user.microposts.count) }
    end

    describe "micropost pagination" do      
      before do
        30.times { FactoryGirl.create(:micropost, user: user) }
        visit user_path(user)
      end 
      after(:all) { Micropost.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each micropost" do
        user.microposts.paginate(page: 1).each do |m|
          expect(page).to have_selector('li', text: m.content)
        end
      end
    end

    describe "follow/unfollow buttons" do
      let(:other_user) {  FactoryGirl.create(:user) }
      before { sign_in user }

      describe "following a user" do
        before { visit user_path(other_user) }

        it "should increment the followed user count" do
          expect do
            click_button "Follow"
          end.to change(user.followed_users, :count).by(1)
        end

        it "should increment the other user's followers count" do
          expect do
            click_button "Follow"
          end.to change(other_user.followers, :count).by(1)
        end

        describe "toggling the button" do
          before { click_button "Follow" }
          it { should have_xpath("//input[@value='Unfollow']") }
        end
      end

      describe "unfollowing a user" do
        before do
          user.follow!(other_user)
          visit user_path(other_user)
        end

        it "should decrement the followed user count" do
          expect do
            click_button "Unfollow"
          end.to change(user.followed_users, :count).by(-1)
        end

        it "should decrement the other user's followers count" do
          expect do
            click_button "Unfollow"
          end.to change(other_user.followers, :count).by(-1)
        end

        describe "toggling the button" do
          before { click_button "Unfollow" }
          it { should have_xpath("//input[@value='Follow']") }
        end
      end
    end #follow/unfollow buttons

  end

  describe "signup" do
    before { visit signup_path }
    let(:submit) { I18n.t("helpers.submit.create", model: I18n.t("activerecord.models.user") ) }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
        before { click_button submit }

        it { should have_title('Sign up') }
        it { should have_content('erro') }
      end
    end

    describe "with valid information" do
      before do
        fill_in_user(name: "Example User", email: "user@example.com", password: "foobar", password_confirmation: "foobar")
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after save the user" do
        before { click_button submit }
        let(:user) { User.find_by_email('user@example.com') } 

        it { should have_link(I18n.t('layouts.header.sign_out')) }
        it { should have_title(User.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome')}
      end
    end
  end #signup

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    let(:edit_button) { I18n.t("helpers.submit.update", model: I18n.t("activerecord.models.user")) }

    before do
      sign_in(user)
      visit edit_user_path(user) 
    end
     
    it { should have_title 'Edit user' }
    it { should have_content I18n.t('users.edit.update_your_profile') }
    it { should have_link I18n.t('users.edit.change'), href: 'http://gravatar.com/emails' }

    describe "with invalid information" do
      before { click_button edit_button }

      it { should have_content('erro') }
    end

   describe "with valid information" do
      let(:new_name)  { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in_user(name: new_name, email: new_email, password: user.password, password_confirmation: user.password)
        click_button edit_button
      end

      it { should have_title(new_name) }
      it { should have_selector('div.alert.alert-success') }
      #it { should have_link('Sign out', href: signout_path) }
      specify { expect(user.reload.name).to  eq new_name }
      specify { expect(user.reload.email).to eq new_email }
    end
  end #edit

  describe "following/followers" do
    let(:user) { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user) }
    before { user.follow!(other_user) }

    describe "following users" do
      before { sign_in user }

      context "when seeing his own profile" do
        before { visit following_user_path user }

        it { should have_title('Following') }
        it { should have_selector('h3', text: 'Following') }
        it { should have_link(other_user.name, href: user_path(other_user)) }  
      end

      context "when seeing the other_profile" do
        before { visit following_user_path other_user }

        it { should have_title('Following') }
        it { should have_selector('h3', text: 'Following') }
        it { should_not have_link(other_user.name, href: user_path(other_user)) }  
      end

    end

    describe "followers" do
      before { sign_in user }

      context "when seeing his own profile" do
        before { visit followers_user_path(user) }          

        it { should have_title('Followers') }
        it { should have_selector('h3', text: 'Followers') }
        it { should_not have_link(user.name, href: user_path(user)) }
      end

      context "when seeing the other_profile" do
        before { visit followers_user_path(other_user) }

        it { should have_title('Followers') }
        it { should have_selector('h3', text: 'Followers') }
        it { should have_link(user.name, href: user_path(user)) }
      end
    end
  end #following/followers
end
