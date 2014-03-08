require 'spec_helper'

describe "User pages" do
	subject { page } 

  describe "Profile page" do
  	let(:user) { FactoryGirl.create(:user) }
  	before { visit user_path(user) }
  	it { should have_content(user.name) }
  	it { should have_title(user.name) }
  end

  describe "signup" do
    before { visit signup_path }
    let(:submit) { "Save" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
        before { click_button submit }

        it { should have_title('Sign up') }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name",         with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after save the user" do
        before { click_button submit }
        let(:user) { User.find_by_email('user@example.com') } 

        it { should have_link('Sign out') }
        it { should have_title(User.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome')}
      end
    end
  end #signup

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit edit_user_path(user) }

    it { should have_title 'Edit user' }
    it { should have_content 'Update your profile' }
    it { should have_link 'change', href: 'http://gravatar.com/emails' }

    describe "with invalid information" do
      before { click_button 'Save' }

      it { should have_content('error') }
    end
  end #edit

end
