class OrdersController < ApplicationController
  
  before_filter :is_owner
  
  def new
    @order = Order.new
    @business = Business.find_by_id(params[:business_id])
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @order }
    end
  end

  # POST /orders
  # POST /orders.xml
  def create
    @order = Order.new(params[:order])
    @order.business_id = params[:business_id]
    @order.ip_address = request.remote_ip
    if @order.save 
      @response = @order.purchase
      p @response
      if @response.success?
        @business = Business.find_by_id(params[:business_id])
        @business.update_attribute(:is_premium, PREMIUM)
        flash[:message] = "Transaction Successful. Your business will now appear in premium listings."
        redirect_to business_path(params[:business_id])
      else
        flash[:notice] = @response.message
        render :action => "new"
      end
    else
      flash[:notice] = "Transaction failed. Please try again."
      render :action => "new"
    end
  end

 private
    def is_owner
      @business = Business.find_by_id(params[:business_id])
      if @business.business_relations.find(:first, :conditions => ["member_id = ? AND status = ?",@member.id,RELATION[:OWNED]])
        return true
      else
        flash[:notice] = "Don't try to mess with me :-/"
        redirect_to business_path(params[:business_id])
      end
    end
end
