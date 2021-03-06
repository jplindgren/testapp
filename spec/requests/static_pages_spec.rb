require 'spec_helper'

include ApplicationHelper

#do not forget to add in spec_helper the capybara DSL
describe "Static pages" do
  subject { page }
  let(:base_title) { 'MicroTwitter ' } 
  
  shared_examples_for "all static pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_title(full_title(page_title)) }
  end

  describe "Home Page" do
    before { visit root_path }

    let(:heading) { 'MicroTwitter' }
    let(:page_title) { '' }

    it_should_behave_like "all static pages"
    it { should_not have_title('| Home')}

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
        sign_in user
        visit root_url
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          expect(page).to have_selector("li##{item.id}", text: item.content)
        end
      end
      
      describe "follower/following users" do
        let(:other_user) { FactoryGirl.create (:user) }
        before do
          other_user.follow!(user)
          visit root_path 
        end

        it { should have_link("0 #{I18n.t('shared.follow.stats.following')}", href: following_user_path(user)) }
        it { should have_link("1 #{I18n.t('shared.follow.stats.followers')}", href: followers_user_path(user)) }
      end
    end
  end

  describe "Help page" do
    before { visit help_path }

    let(:heading) { I18n.t("help") }
    let(:page_title) { I18n.t("help") }

    it_should_behave_like "all static pages"
  end

  describe "About page" do
    before { visit about_path }

    let(:heading) { "About us" }
    let(:page_title) { "About us" }

    it_should_behave_like "all static pages"
  end

  describe "Contact page" do
    before { visit contact_path }

    let(:heading) { I18n.t("contact") }
    let(:page_title) { I18n.t("contact") }
    
    it_should_behave_like "all static pages"
  end
end
