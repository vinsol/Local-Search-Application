class BusinessesController < ApplicationController
  # GET /businesses
  # GET /businesses.xml
  def index
    @businesses = Business.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @businesses }
    end
  end

  # GET /businesses/1
  # GET /businesses/1.xml
  def show
    @title = "Business Details"
    @business = Business.find(params[:id])

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

  # GET /businesses/1/edit
  def edit
    @member = Member.find_by_id(session[:member_id])
    @business = Business.find(params[:id])
  end

  # POST /businesses
  # POST /businesses.xml
  def create
    @member = Member.find_by_id(session[:member_id])
    @business = Business.new(params[:business]) 
    @business.member_id = @member.id
      if @business.save
        flash[:notice] = 'Business was successfully added.'
        redirect_to member_path(session[:member_id]) 
      else
        render  :action => :new
      end
    
  end

  # PUT /businesses/1
  # PUT /businesses/1.xml
  def update
    @member = Member.find_by_id(session[:member_id])
    @business = Business.find(params[:id])
    
      if @business.update_attributes(params[:business])
        flash[:notice] = 'Business was successfully updated.'
        redirect_to member_path(session[:member_id]) 
      else
        render :action => :new
      end
    
  end

  # DELETE /businesses/1
  # DELETE /businesses/1.xml
  def destroy
    @business = Business.find(params[:id])
    @business.destroy
    redirect_to member_path(session[:member_id])
  end
  
end
