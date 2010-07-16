class BusinessesController < ApplicationController
  
 skip_before_filter :authorize, :only => [:index, :search, :show, :locations, :business_names, :send_to_phone]
 
  def index
    @businesses = Business.paginate :page => params[:page], :order => 'name ASC'
    @title = "Listing Businesses"
  end

  
  
  def show
    @business = Business.find(params[:id])
    @title = "Business Details - #{@business.name}"
    #Edit and Delete for owners and Add to Favorites for those who haven't added it yet.
 
    @map = Business.get_map(@business.lat, @business.lng, @business.name) unless @business.lat == nil && @business.lng ==nil
  end

  
  def new
    @title = "Add Business"
    @business = Business.new
  end
    
  def edit
    @title = "Edit Business"
    @business = Business.find(params[:id])
  end

  def send_to_phone
    @business = Business.find_by_id(params[:id])
    business_details = "#{@business.name} - #{@business.contact_phone}" +
                        " - #{@business.contact_address}, #{@business.location}, #{@business.city}" 
    ##########################################################################################
    
    #SMS GATEWAY API
    url_details = URI.escape(business_details, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
    url = SMS_API + "#{url_details}&recipient=#{params[:number]}"
    Net::HTTP.get_print URI.parse(url)
    ############################################################################################
    
    respond_to  do |format|
      format.js
    end
  end
 
  def create
    @business = Business.new(params[:business])
    @business.owner = @member.full_name
    if @business.save and BusinessRelation.create(:member_id => @member.id,
                                                  :business_id => @business.id, 
                                                  :status => RELATION[:OWNED])
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
      if BusinessRelation.create( :member_id => @member.id, 
                                  :business_id => @business.id, 
                                  :status => RELATION[:FAVORITE])
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

    
    
end
