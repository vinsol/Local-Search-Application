class BusinessesController < ApplicationController
 
  def index
    @businesses = Business.all
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
    #Do not show Add to favorite list to owners 
    #or to the people who have already added the business as favorite
    if !is_favorite(@business)
      @favorite = true
    end
   
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @business }
    end
  end

  
  def new
    @title = "Add Business"
    @member = Member.find_by_id(session[:member_id])
    @business = Business.new 
  end

 
  def edit
    @member = Member.find_by_id(session[:member_id])
    @business = Business.find(params[:id])
    if !is_owner(@business) 
      flash[:notice] = "Mind your own fu**ing business"
      redirect_to member_path(@member.id)
    end
  end

  #Status = 1 for owners and status = 0 for favorites
  def create
    @member = Member.find_by_id(session[:member_id])
    @business = Business.new(params[:business]) 
    @business.owner = @member.first_name + " " + @member.last_name
    if @business.save
        @business_relation = BusinessRelation.new
        @business_relation.member_id = session[:member_id]
        @business_relation.business_id = @business.id
        @business_relation.status = 1
        if @business_relation.save
          flash[:message] = 'Business was successfully added.'
          redirect_to member_path(session[:member_id]) 
        else
          @business.destroy
        end
    else
        render  :action => :new
      end
    
  end

  def update
    if request.put?
      @member = Member.find_by_id(session[:member_id])
      @business = Business.find(params[:id])
      if is_owner(@business) 
        if @business.update_attributes(params[:business])
          flash[:message] = 'Business was successfully updated.'
          redirect_to business_path(params[:id])
        else
          render :action => :new
        end
      else
        flash[:notice] = "Nice Try Dumbass."
        redirect_to member_path(@member.id)
      end 
    end
  end

 
  def destroy
    @business = Business.find(params[:id])
    if is_owner(@business) 
      @business.destroy
      flash[:message] = "Business was successfully deleted"
      redirect_to member_path(session[:member_id])
    else
      flash[:notice] = "You can delete your own businesses"
      redirect_to member_path(session[:member_id])
    end
  end
  
  def add_favorite
    @business = Business.find_by_id(params[:id])
    if is_favorite(@business) 
      flash[:notice] = "Business already in your favorite list"
      redirect_to business_path(params[:id])
    else
      @business_relation = BusinessRelation.new
      @business_relation.member_id = session[:member_id]
      @business_relation.business_id = @business.id
      @business_relation.status = 0
      if @business_relation.save
        flash[:message] = "Business added to your list"
        redirect_to member_path(session[:member_id])
      else
        flash[:notice] = "Unable to add business to your list. Try again."
        redirect_to business_path(params[:id])
      end
    end
  end
  
  protected
    
    #Checks whether the person is owner or not.
    def is_owner(business)
      if business.business_relations.find_by_member_id(session[:member_id]) 
        if business.business_relations.find_by_member_id(session[:member_id]).status == 1
          return true
        end
      else
        return false
      end
    end
    #checks whether the person has added the business as favorite. Also checks whether he owns the business or not.
    def is_favorite(business)
      if business.business_relations.find_by_member_id(session[:member_id]) 
        if business.business_relations.find_by_member_id(session[:member_id]).status >= 0
          return true
        end
      else
        return false
      end
    end
    
end
