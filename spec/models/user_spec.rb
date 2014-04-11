require 'spec_helper'
require 'ruby-debug'

describe User do
  before { @user = User.new(email:"joaopozo@gmail.com", name: "Joao Paulo Lindgren", password: "123456", password_confirmation: "123456") }

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:admin) }
  it { should respond_to(:microposts) }

  it {should respond_to(:authenticate) }

  it { should_not be_admin }
  it { should be_valid }

  describe "When name is not present" do
  	before { @user.name = "" }
  	it { should_not be_valid }
  end

  describe "accessible attributes" do
    it "should not allow access to admin" do
      expect do
        User.new(admin: true)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe "When email is not present" do
  	before { @user.email = " " }

  	it { should_not be_valid}
  end

  describe "When name length is bigger then the limit" do
  	before { @user.name = "a" * 51 }
  	it { should_not be_valid }
  end

  describe "when email format is invalid" do
  	it "should be invalid" do
  		address = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
        address.each do |invalid_address|
        	@user.email = invalid_address
        	expect(@user).not_to be_valid
        end
  	end
  end

  describe "when email format is valid" do
  	it "should be valid" do
  		addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn userfoo@g.mail.com]
  		addresses.each do |valid_address|
  			@user.email = valid_address
  			expect(@user).to be_valid
  		end
  	end
  end

  describe "when email address is already taken" do
  	before do
  		user_with_same_email = @user.dup
  		user_with_same_email.save
  	end

  	it { should_not be_valid }
  end

  describe "when email address is already taken" do
  	before do
  		user_with_same_email = @user.dup
  		user_with_same_email.email = @user.email.upcase
  		user_with_same_email.save
  	end

  	it { should_not be_valid }
  end

  describe "when passowrd is not presented" do
    before do
      @user = User.new(name: "Example User", email: "user@example.com",
                       password: " ", password_confirmation: " ")
    end
    it { should_not  be_valid }
  end

  describe "when password does not match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  describe "when save an email" do
    let(:mixed_case_email) { "JOAOPOZO@gmail.COM" }
    
    it "should be saved as all low case" do
      @user.email = mixed_case_email
      @user.save
      expect(@user.reload.email).to eq mixed_case_email.downcase
    end
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:user_found) { User.find_by_email(@user.email) }

    describe "with valid password" do
      it { should eq user_found.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { @user.authenticate("invalid") }
      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_false }
    end
  end

  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end

  describe "remember_token" do
    before { @user.save }
    #its(:remember_token) { should_not be_blank } does not get a fluent error message! Why?
    it { expect(@user.remember_token).not_to be_blank }
  end

  describe "with admin attribute set to to 'true'" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end 
    it { should be_admin }
  end

  describe "micropost associations" do
    before { @user.save }
    let!(:older_micropost) { FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)  } 
    let!(:newer_micropost) { FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago) }

    it "should have the right microposts in the right order" do
      @user.microposts.should == [newer_micropost, older_micropost]
    end

    it "should destroy associated micrposts when deleted" do
      microposts = @user.microposts.dup
      @user.destroy
      microposts.should_not be_empty
      microposts.each do |m|
        Micropost.find_by_id(m.id).should be_nil
      end
    end
  end #micropost associations
end
