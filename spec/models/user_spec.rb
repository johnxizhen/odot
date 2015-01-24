require 'spec_helper'

describe User do
  let(:valid_attributes) {
    {
      first_name: "John",
      last_name: "Li",
      email: "johnli@ecenglish.com",
      password: "administrator",
      password_confirmation: "administrator"
      }
    }
  
  context "relationships" do
    it { should have_many(:todo_lists) }
  end
  
  context "validations" do
    let(:user) { User.new(valid_attributes) }
    
    before do
      User.create(valid_attributes)
    end
    
    it "requires an email" do
      expect(user).to validate_presence_of(:email)
    end
    
    it "requires a unique email" do
      expect(user).to validate_uniqueness_of(:email)
    end
    
    it "requires a unique email (case insensitive)" do
      user.email = "JOHNLI@ECENGLISH.COM"
      expect(user).to validate_uniqueness_of(:email)
    end
    
    it "requires the email address to look like an email" do
      user.email ="jason"
      expect(user).to_not be_valid
    end
  end
  
  # context can also be used instead of describe
  describe "#downcase_email" do
    it "make the email attribute lower case" do
      user = User.new(valid_attributes.merge(email: "KJCHO@ECENGLISH.COM"))
      # user.downcase_email
      # expect(user.email).to eq("kjcho@ecenglish.com")
      expect{ user.downcase_email }.to change{ user.email }.
        from("KJCHO@ECENGLISH.COM").
        to("kjcho@ecenglish.com")
    end
           
    it "downcases an email before saving" do
      user = User.new(valid_attributes)
      user.email = "JOHNLI@ECENGLISH.COM"
      expect(user.save).to be_truthy
      expect(user.email).to eq("johnli@ecenglish.com")
    end
  end
  
  describe "#generate_password_reset_token!" do
    let(:user) { create(:user) }
    
    it "changes the password_reset_token attribute" do
      expect{ user.generate_password_reset_token! }.to change{user.password_reset_token}      
    end
    
    it "calls SecureRandom.urlsafe_base64 to generate the password_reset_token" do
      expect(SecureRandom).to receive(:urlsafe_base64)
      user.generate_password_reset_token!
    end
  end
end
