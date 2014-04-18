require "spec_helper"

describe RelationshipMailer do
  describe "new_follower_notification" do
    let(:follower) { FactoryGirl.create(:user) }
    let(:followed) { FactoryGirl.create(:user) }
    

    before do
      follower.follow!(followed)
      @mail = RelationshipMailer.new_follower_notification(followed, follower)
    end

    it "renders the headers" do
      @mail.subject.should eq("#{follower.name} is following you!")
      @mail.to.should eq([ followed.email ])
      @mail.from.should eq(["jpdesenvolver@gmail.com"])
    end

    it "renders the body" do
      @mail.body.encoded.should match("#{follower.name}, is following you!")
    end
  end

end
