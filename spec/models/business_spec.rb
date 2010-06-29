require 'spec_helper'

describe Business do
  before(:each) do
    @valid_attributes = { :name => "Business_temp",
                          :location => "Rajiv Chowk",
                          :city => "Delhi",
                          :category => "Healthcare",
                          :sub_category => "chemist",
                          :contact_name => "Jigar", 
                          :contact_phone => "9898989898",
                          :contact_address => "C-2, West Patel Nagar, Delhi",
                          :opening_time => Time.now,
                          :closing_time => Time.now + 5,
                          :lat => 77.777777,
                          :lng => 77.777777
      
    }
  end
  
  it "should create a new instance given valid attributes" do
    Business.create!(@valid_attributes)
  end
  
  describe "validations" do
    
    it "should require a name" do
      Business.new(@valid_attributes.merge(:name => " ")).should_not be_valid
    end
    
    it "should require a valid location" do
      Business.new(@valid_attributes.merge(:location => " ")).should_not be_valid
    end
    
    it "should require a valid city" do
      Business.new(@valid_attributes.merge(:city => " ")).should_not be_valid
    end
      
    it "should require a valid category" do
      Business.new(@valid_attributes.merge(:category => " ")).should_not be_valid
    end
        
    it "should require a valid sub_category" do
      Business.new(@valid_attributes.merge(:sub_category => " ")).should_not be_valid
    end
    
    it "should require a valid contact_name" do
      Business.new(@valid_attributes.merge(:contact_name => " ")).should_not be_valid
    end
    it "should require a valid contact_phone" do
      Business.new(@valid_attributes.merge(:contact_phone => " ")).should_not be_valid
    end
    
    it "should require a valid contact_address" do
      Business.new(@valid_attributes.merge(:contact_address => " ")).should_not be_valid
    end
    
    describe "format validations" do
      it "should have a valid phone format" do
        Business.new(@valid_attributes.merge(:contact_phone => "9898")).should_not be_valid
      end
      
      it "should have a valid website url" do
        Business.new(@valid_attributes.merge(:contact_website => "test_invalid")).should_not be_valid
      end
      
      it "should have a valid email" do
        Business.new(@valid_attributes.merge(:contact_email => "invalid")).should_not be_valid
      end
      
    end
    
    it "should have closing time greater than opening time" do
      Business.new(@valid_attributes.merge( :opening_time => Time.now.succ, :closing_time => Time.now)).should_not be_valid
    end
  end
  
  #Test Photo Attachments    
  describe "photo upload" do
    before(:each) do
      @file = File.new(File.join(RAILS_ROOT, "/spec/fixtures", "temp.pdf"), 'rb')
    end
    
    it "should not allow formats other than jpg, png or gif" do
      Business.new(@valid_attributes.merge(:photo => @file)).should_not be_valid
    end
    
    it "should not allow files larger than 1 megabyte" do
      Business.new(@valid_attributes.merge(:photo => @file)).should_not be_valid
    end
  end
  
  #Test Relations
  describe "realtions" do
    fixtures :members, :businesses, :business_relations
    
    it "should have members" do
      @business = Business.find(businesses(:business_1))
      @business.members.should_not be_empty
    end
    
  end
  
end
