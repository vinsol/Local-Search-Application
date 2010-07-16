class OrdersController < ApplicationController
  
  before_filter :is_owner
  
  def new
    @order = Order.new
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
    if @order.valid?
      if @order.save!
        begin
          if @order.purchase.success?
            flash_redirect("message","Transaction Successful.","business_path(params[:business_id])")
          else
            flash_render("notice",@response.message,"new")
          end
        rescue SocketError 
          flash_render("notice","Unable to connect to payment gateway. Please try again.","new")
        rescue ActiveMerchant::ConnectionError
          flash_render("notice","Connection timeout. Please try again","new")
        end
      else
        flash_render("notice","Unable to save the order. Please try again.","new")
      end
    else
      flash_render("notice","Incorrect form values.","new")
    end
  end
  
end
