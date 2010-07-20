class OrdersController < ApplicationController
  
  before_filter :check_if_owner
  
  def new
    @order = Order.new
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
    flash_redirect("notice",":-/",business_path(params[:business_id])) unless is_owner(@business)
   end
   
end
