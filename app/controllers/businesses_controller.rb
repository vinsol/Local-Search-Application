class BusinessesController < ApplicationController
 
  def index
    @businesses = Business.paginate :page => params[:page], :order => 'name ASC'
    @title = "Listing Businesses"
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @businesses }
    end
  end

  def show
    @member = Member.find_by_id(session[:member_id])
    @business = Business.find(params[:id])
    @title = "Business Details - #{@business.name}"
    #Edit and Delete for owners and Add to Favorites for those who haven't added it yet.
    @favorite = true unless is_favorite(@business)
    @owner = true if is_owner(@business)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @business }
    end
  end

  def new
    @title = "Add Business"
    @cities = City.find(:all)
    @member = Member.find_by_id(session[:member_id])
    @business = Business.new
  end

  def get_locations
    unless request.xhr?
    flash[:error] = ‘Invalid page’
    redirect_to root_path
    else
    @locations = City.find_by_city(params[:business_city]).locations
    render :partial=> "business_location"
    end
  end
  
  def get_sub_categories
    unless request.xhr?
    flash[:error] = ‘Invalid page’
    redirect_to root_path
    else
    @sub_categories = Category.find_by_category(params[:business_category]).sub_categories
    render :partial=> "business_sub_category"
    end
  end
    
  def edit
    @title = "Edit Business"
    @member = Member.find_by_id(session[:member_id])
    @business = Business.find(params[:id])
    unless is_owner(@business) 
      redirect_to_profile('Business was successfully added.', 'notice')
    end
  end

 
  def create
    @member = Member.find_by_id(session[:member_id])
    @business = Business.new(params[:business])
    @business.owner = @member.first_name + " " + @member.last_name
    if @business.save and BusinessRelation.create(:member_id => session[:member_id], :business_id => @business.id, :status => RELATION[:OWNED])
      flash[:message] = "Business successfully added"      
      redirect_to businesses_path
    else
      @business.destroy
      render  :action => :new
    end
  end

  def update
    if request.put?
      @member = Member.find_by_id(session[:member_id])
      @business = Business.find(params[:id])
      #### Allow only if the user owns the business
      if is_owner(@business) 
        if @business.update_attributes(params[:business])
          flash[:message] = 'Business was successfully updated.'
          redirect_to business_path(params[:id])
        else
          render :action => :edit
        end
      else
        redirect_to_profile("Nice Try","notice")
      end 
    end
  end

 
  def destroy
    @business = Business.find(params[:id])
    if is_owner(@business) 
      if @business.destroy
        redirect_to_profile("Business was successfully deleted","message")
      else
        redirect_to business_path(@business.id)
      end
    else
      redirect_to_profile("You can delete your own businesses only","notice")
    end
  end
  
  def add_favorite
    @business = Business.find_by_id(params[:id])
    #Adding same business twice in the list is not allowed
    if is_favorite(@business) 
      flash[:notice] = "Business already in your favorite list"
      redirect_to :back
    else
      if BusinessRelation.create(:member_id => session[:member_id], :business_id => @business.id, :status => RELATION[:FAVORITE])
        @ajax_alert = "Business added to your list"
        p '========>>>>>>>'
        p @ajax_alert
        respond_to do |format|
          format.js 
        end
      else
        flash[:notice] = "Unable to add business to your list. Try again."
        redirect_to :back
      end
    end
  end
  
  def remove_favorite
    @business = Business.find_by_id(params[:id])
    #Cannot remove business if it is not in favorite
    if !is_favorite(@business)
      flash[:notice] = "Business not in your list"
      redirect_to :back
    else
      if BusinessRelation.destroy(@favorite.id)
        @ajax_alert = "Business removed from your list"
        respond_to do |format|
          format.js 
        end
      else
        flash[:notice] = "Unable to remove from list. Please try again."
        redirect_to :back
      end
    end
  end
  protected
    
    #Checks whether the person is owner or not.
    def is_owner(business)
      if business.business_relations.find(:first, :conditions => ["member_id = ? AND status = ?",session[:member_id],RELATION[:OWNED]])
        return true
      else
        return false
      end
    end
    
    #checks whether the person has added the business as favorite.
    
    def is_favorite(business)
      @favorite = business.business_relations.find(:first, :conditions => ["member_id = ? AND status = ?",session[:member_id],RELATION[:FAVORITE]])
      if @favorite
        return true
      else
        return false
      end
    end
    
    
end
