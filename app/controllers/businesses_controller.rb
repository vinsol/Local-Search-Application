class BusinessesController < ApplicationController
 skip_before_filter :authorize, :only => [:index, :search, :show, :locations, :business_names, :send_to_phone]
 before_filter :find_business_by_id, :only => [:show, :edit, :send_to_phone, :update, :destroy,
                                                :add_favorite, :remove_favorite ]
 
  def index
    @businesses = Business.paginate :page => params[:page], :order => 'name ASC'
    @title = "Listing Businesses"
  end

  def show
    @title = "Business Details - #{@business.name}"
    #Get business map
    @map = @business.get_map 
    p @map
  end

  def new
    @title = "Add Business"
    @business = Business.new
  end
    
  def edit
    @title = "Edit Business"   
  end

  def send_to_phone
    @business.send_sms(params[:number])
    respond_to  do |format|
      format.js
    end
  end
 
  def create
    @business = Business.new(params[:business])
    @business.owner = @member.full_name
    @business.business_relations.build(:member_id => @member.id,:status => RELATION[:OWNED])
    if @business.save
      flash_redirect("message","Business was successfully added",businesses_path)
    else
      flash_render("notice", "Unable to save business", "new")
    end
  end

  def update
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
    #Adding same business twice in the list is not allowed
    if is_favorite(@business) 
      flash_redirect("notice", "Business already in your list", session[:return_to])
    else
      if @business.business_relations.create(:member_id => @member.id, :status => RELATION[:FAVORITE])
        respond_to do |format|
          format.js 
        end
      else
        flash_redirect("notice","Unable to add business to your list. Try again.",session[:return_to])
      end
    end
  end
  
  def remove_favorite
    #Cannot remove business if it is not in favorite
    unless is_favorite(@business)
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

  private 
    def find_business_by_id
      @business = Business.find_by_id(params[:id])
    end
    
end
