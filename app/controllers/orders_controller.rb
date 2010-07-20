class OrdersController < ApplicationController
  
  before_filter :check_if_owner
  
  def new
    @order = Order.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @order }
    end
  end

 
  def create
    @order = Order.new(params[:order])
    @order.business_id, @order.ip_address = params[:business_id], request.remote_ip
    if @order.valid?
      if @order.save!
        begin
          if @order.purchase.success?
            flash_redirect("message","Transaction Successful.",business_path(params[:business_id]))
          else
            flash_render("notice",@response.message,"new")
          end
        rescue SocketError => e
          logger.warn e.message
          flash_render("notice","Unable to connect to payment gateway. Please try again.","new")
        rescue ActiveMerchant::ConnectionError
          logger.warn e.message
          flash_render("notice","Connection timeout. Please try again","new")
        end
      else
        flash_render("notice","Unable to save the order. Please try again.","new")
      end
    else
      flash_render("notice","Incorrect form values.","new")
    end
  end
  
  private
  
   def check_if_owner
    @business = Business.find_by_id(params[:business_id])
    unless @business.business_relations.find(:first, :conditions => ["member_id = ? AND status = ?",  
                                                                     @member.id,RELATION[:OWNED]])
     
      flash[:notice] = "Don't try to mess with me :-/"
      redirect_to business_path(params[:business_id])
    end
   end
   
end
