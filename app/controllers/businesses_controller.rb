class BusinessesController < ApplicationController
  
 skip_before_filter :authorize, :only => [:index, :search, :show, :locations, :business_names, :send_to_phone]
 
  def index
    @businesses = Business.paginate :page => params[:page], :order => 'name ASC'
    @title = "Listing Businesses"
  end

  def search
    @conditions = Hash.new
    @conditions[:name] = params[:name] if params[:name] != "" and params[:name] != nil and params[:name] != "Name"
    @conditions[:city] = params[:city] if params[:city] != "" and params[:city] != nil and params[:city] != "City Name"
    @conditions[:location] = params[:location] if params[:location] != "" and params[:location] != nil and params[:location] != "Location"
    @conditions[:category] = params[:category] if params[:category] != "" and params[:category] != nil
    @conditions[:sub_category] = params[:sub_category_name] if params[:sub_category_name] != "" and params[:sub_category_name] != nil and params[:sub_category_name] != "Product/Service Category"
    if @conditions != {}
      @search_results = Business.search :conditions => @conditions
      if @search_results.empty?
        @text = "No results found."
      end
    else
      @text = "Enter valid parameters"
    end
  end
  
  def show
    @business = Business.find(params[:id])
    @title = "Business Details - #{@business.name}"
    #Edit and Delete for owners and Add to Favorites for those who haven't added it yet.
    if @member
      @favorite = true unless is_favorite(@business)
      @owner = true if is_owner(@business)
    else
      @favorite = false
      @owner = false
    end
    if @business.lat != nil and @business.lng != nil
      @map = GoogleMap::Map.new
      @map.center = GoogleMap::Point.new(@business.lat, @business.lng)
      @map.zoom = 15
      @map.markers << GoogleMap::Marker.new(  :map => @map,
                                              :lat => @business.lat,
                                              :lng => @business.lng,
                                              :html => @business.name)
    end
  end

  
  def new
    @title = "Add Business"
    @business = Business.new
  end

    
  def locations
    @city = City.find(:first, :conditions => ['city LIKE ?', "%#{params[:city]}"])
    @search_query = params[:search][SEARCH_REGEX,2]
    if @city != nil
      @locations = @city.locations.find(:all, 
                                        :conditions => ['location LIKE ?',"%#{@search_query}%"]) 
    else
      @locations = Location.find( :all, 
                                  :conditions => ['location LIKE ?',"%#{@search_query}%"])
    end
  end
  
  def business_names
    @search_query = params[:search][SEARCH_REGEX,2]
    @businesses = Business.find(:all,
                                :conditions => ['name LIKE ?',"%#{@search_query}%"])
  end
    
  def edit
    @title = "Edit Business"
    @business = Business.find(params[:id])
  end

  def send_to_phone
    @business = Business.find_by_id(params[:id])
    @business_details = "#{@business.name} - #{@business.contact_phone} - #{@business.contact_address}, #{@business.location}, #{@business.city}"
    
    @url_details = URI.escape(@business_details, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
    url = "http://s1.freesmsapi.com/messages/send?skey=11ae2fd4c2f0b7346d3cf11d97969778&message=#{@url_details}&recipient=#{params[:number]}"
    Net::HTTP.get_print URI.parse(url)
    respond_to  do |format|
      format.js
    end
  end
 
  def create
    @business = Business.new(params[:business])
    @business.owner = @member.full_name
    if @business.save and BusinessRelation.create(:member_id => @member.id,:business_id => @business.id, :status => RELATION[:OWNED])
      flash_redirect("message","Business was successfully added",businesses_path)
    else
      @business.destroy
      render  :action => :new
    end
  end

  def update
    @business = Business.find(params[:id])
    #### Allow only if the user owns the business
    if is_owner(@business) 
      if @business.update_attributes(params[:business])
        flash_redirect("message","Business was successfully added",business_path(params[:id]))
      else
        render :action => :edit
      end
    else
      flash_redirect("notice", "Nice try", member_path(@member.id))
    end 
  end

 
  def destroy
    @business = Business.find(params[:id])
    if is_owner(@business) 
      if @business.destroy
        flash_redirect("message","Business was successfully deleted",member_path(@member.id))
      else
        redirect_to business_path(@business.id)
      end
    else
      flash_redirect("notice","You can delete your own business",member_path(@member.id))
    end
  end
  
  def add_favorite
    @business = Business.find_by_id(params[:id])
    #Adding same business twice in the list is not allowed
    if is_favorite(@business) 
      flash_redirect("notice", "Business already in your list", session[:return_to])
    else
      if BusinessRelation.create(:member_id => @member.id, :business_id => @business.id, :status => RELATION[:FAVORITE])
        respond_to do |format|
          format.js 
        end
      else
        flash_redirect("notice","Unable to add business to your list. Try again.",session[:return_to])
      end
    end
  end
  
  def remove_favorite
    @business = Business.find_by_id(params[:id])
    #Cannot remove business if it is not in favorite
    if !is_favorite(@business)
      flash_redirect("notice","Business not in your list",session[:return_to])
    else
      if BusinessRelation.destroy(@business_relation.id)
        respond_to do |format|
          format.js 
        end
      else
        flash_redirect("notice","Unable to remove from list. Please try again.",session[:return_to])
      end
    end
  end
  
  protected
    
    #Checks whether the person is owner or not.
    def is_owner(business)
      if business.business_relations.find(:first, :conditions => ["member_id = ? AND status = ?",@member.id,RELATION[:OWNED]])
        return true
      else
        return false
      end
    end
    
    #checks whether the person has added the business as favorite.
     def is_favorite(business)
      if @business_relation = business.business_relations.find(:first, :conditions => ["member_id = ? AND status = ?",@member.id,RELATION[:FAVORITE]])
        return true
      else
        return false
      end
    end
    
    
end
