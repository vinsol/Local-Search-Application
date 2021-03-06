require 'spec_helper'

describe Member do
  before(:each) do
    @valid_attributes = { :first_name => "Mohit",
                          :last_name  => "Jain",
                          :email      => "mohit123@gmail.com",
                          :phone_number => "9898989898",
                          :address => "C-2, West Patel Nagar, Delhi",
                          :password => "google",
                          :password_confirmation => "google"
                          
    }
  end
#Member Validations -> validations on presence and uniqueness

  describe "validations" do
    
    it "should create a new instance given valid attributes" do
      Member.create!(@valid_attributes)
    end
  
    it "should require an email address" do
      member = Member.new(@valid_attributes.merge(:email => ""))
      member.should_not be_valid
    end
  
    it "should require a valid email address" do
      member = Member.new(@valid_attributes.merge(:email => ""))
      member.should_not be_valid
    end
  
    it "should require first name" do
      member = Member.new(@valid_attributes.merge(:first_name => ""))
      member.should_not be_valid
    end
   
    it "should require last name" do
      member = Member.new(@valid_attributes.merge(:last_name => ""))
      member.should_not be_valid
    end 
  
    it "should require a phone number" do
      member = Member.new(@valid_attributes.merge(:phone_number => ""))
      member.should_not be_valid
    end
  
    it "should require a valid phone number" do
      member = Member.new(@valid_attributes.merge(:phone_number => "asflhajksgdkasd"))
      member.should_not be_valid
    end
    
    it "should have a valid email" do
      Member.new(@valid_attributes.merge(:email => "invalid")).should_not be_valid
    end
    
    it "should have an unique email" do
       member1 = Member.create!(@valid_attributes)
       Member.new(@valid_attributes).should_not be_valid
     end
     
  end
  
 
#Password Validations  
  
  describe "password validations" do
    
    it "should require a password" do
      Member.new(@valid_attributes.merge(:password => " ", :confirm_password => " ")).
        should_not be_valid
    end
  
    it "should require a matching password confirmation" do
      Member.new(@valid_attributes.merge(:password_confirmation => "invalid")).
        should_not be_valid
    end
    
  end
  
  describe "Full Name" do
    it "should return a full name" do
      @member = Member.create(@valid_attributes)
      @member.full_name.should == "Mohit Jain"
    end
  end
  
  
  #Password Encryption
 
  describe "password encryption" do
    
    before(:each) do
      @member = Member.create!(@valid_attributes)
    end
    
    it "should have a hashed password attribute" do
      @member.should respond_to(:hashed_password)
    end
    
    it "should have a salt attribute" do
      @member.should respond_to(:salt)
    end
    
    it "should set a salt value" do
      @member.salt.should_not be_blank
    end
    
    it "should set a hashed password" do
      @member.hashed_password.should_not be_blank
    end
    
    #Test Authentication
    describe "authentication" do
      
      it "should be true if the credentials match" do
        Member.authenticate('mohit123@gmail.com', 'google',nil).should == @member
      end
      
      it "should not be true if the credentials do not match" do
        Member.authenticate('mohit123@gmail.com', 'test',nil).should == nil
      end
      
      it "should set remember me token if remember me is checked" do
        Member.stub!(:generate_random_string).and_return("random_token")
        @member = Member.authenticate('mohit123@gmail.com', 'google',"1")
        @member.remember_me_token.should_not == nil
      end
      
      it "should set remember me time if remember me is checked" do
        Member.stub!(:generate_random_string).and_return("random_token")
        @member = Member.authenticate('mohit123@gmail.com', 'google',"1")
        @member.remember_me_time.should_not == nil
      end
    end
    
  end
  
  #Test Generate random string
  describe "generate random string" do
    
    it "should return a random string of specified length" do
      @member = Member.create!(@valid_attributes)
      @string = @member.generate_random_string(10)
      @string.length.should == 10
    end
    
  end
  
  #Test Email Notifications
  describe "email notifications" do
    
    before(:each) do  
      ActionMailer::Base.delivery_method = :test  
      ActionMailer::Base.perform_deliveries = true  
      ActionMailer::Base.deliveries = []  
      
    end
    
    it "should send a signup notification mail" do
      @member = Member.create!(@valid_attributes)
      ActionMailer::Base.deliveries.size.should == 1  
    end
    
    #Password retrieval mail testing
    
    describe "password retrieval" do
      it "should generate a new password, update the hashed password and send an email" do
        @member = Member.create!(@valid_attributes)
        @member.send_new_password
        Member.authenticate('mohit123@gmail.com', "google",nil).should == nil
        ActionMailer::Base.deliveries.size.should == 2
      end
    end
    
  end
  
  #Test Photo Attachments    
  describe "photo upload" do
    before(:each) do
      @file = File.new(File.join(RAILS_ROOT, "/spec/fixtures", "temp.pdf"), 'rb')
    end
    
    it "should not allow formats other than jpg, png or gif" do
      Member.new(@valid_attributes.merge(:photo => @file)).should_not be_valid
    end
    
    it "should not allow files larger than 1 megabyte" do
      Member.new(@valid_attributes.merge(:photo => @file)).should_not be_valid
    end
    
  end
  
  #Test Member-Business relationships including owned_businesses and favorite_businesses
  describe "relations" do
    fixtures :members, :businesses, :business_relations
    
    it "should have businesses" do
      @member = Member.find(members(:members_001).id)
      @member.business_relations.should_not be_empty
    end
    
    it "should have 5 related business" do
      @member = Member.find(members(:members_001).id)
      @member.business_relations.should have(5).records
    end
    
    it "should have not include other's owned businesses" do
      @member = Member.find(members(:members_001).id)
      @member.owned_businesses.should_not include(businesses(:businesses_004))
    end
    
    it "should have 2 favorite business" do
      @member = Member.find(members(:members_001).id)
      @member.favorite_businesses.should include(businesses(:businesses_006))
    end
    
    it "should not have businesses of other person" do
      @member = Member.find(members(:members_001).id)
      @member.owned_businesses.should_not include(businesses(:businesses_006))
    end
    
  end
  
  #It should delete associated businesses during member deletion
  describe "member deletion" do
    fixtures :members, :businesses, :business_relations
    it "should delete owned and favorite businesses during member deletion" do
      @member = Member.find(members(:members_001).id)
      @member.destroy
      puts @member.owned_businesses
    end
  end
  
end
