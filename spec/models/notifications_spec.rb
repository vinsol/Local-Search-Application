require 'spec_helper'

describe Notifications do
  include EmailSpec::Helpers
  include EmailSpec::Matchers
  
  
  describe "Signup Notification Mail" do
    before(:all) do
          @email = Notifications.deliver_send_notification_mail("Jigar", "Patel", "jagira@gmail.com")
    end
    
    it "should be set to be delivered to the email passed in" do
      @email.should deliver_to("jagira@gmail.com")
    end

    it "should contain the user's name in the mail body" do
      @email.should have_text(/Jigar Patel/)
    end

    it "should have the correct subject" do
      @email.should have_subject(/Signup Notification Mail/)
    end 
  end
  
  describe "Forgot Password Mail" do
    before(:all) do
      @email = Notifications.deliver_forgot_password("jagira@gmail.com", "Jigar", "Patel", "password123")
    end
    
    it "should be set to be delivered to the email passed in" do
      @email.should deliver_to("jagira@gmail.com")
    end

    it "should contain the password in the mail body" do
      @email.should have_text(/password123/)
    end

    it "should have the correct subject" do
      @email.should have_subject(/New Password for your AskMe Account/)
    end
  end
    
end
