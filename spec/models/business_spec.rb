require 'spec_helper'

describe Business do
  fixtures :businesses, :sub_categories
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
                          :lng => 77.777777,
                        
      
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
      @business = Business.find(businesses(:businesses_001))
      @business.members.should_not be_empty
    end
    
  end
  
  it "should set business details" do
    @business = Business.find(businesses(:businesses_001))
    @business.business_details.should_not be_nil
  end
  
  it "should set business title" do
    @business = Business.find(businesses(:businesses_001))
    @business.title.should_not be_nil
  end
  
  it "should send sms" do
    @business = Business.find(businesses(:businesses_001))
    @business.send_sms("9899744815")
  end
  
  it "should fetch string of sub categories" do
    @business = Business.find(businesses(:businesses_001))
    @business.sub_category_name.should_not be_nil
  end
  
  it "should add sub categories to business" do
  
    @business = Business.find(businesses(:businesses_001))
    @business.sub_category_name=("Clinic")
    @business.sub_categories.should include(sub_categories(:sub_categories_002))
  end
  
  it "should fetch the map for a business" do
    @business = Business.find(businesses(:businesses_001))
    @business.get_map.should_not be_nil
  end
  
  
end
