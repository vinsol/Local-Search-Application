module Admin::OrdersHelper
  
  def order_transactions_column(record)
    if record.order_transactions.any?
      record.order_transactions.map {|transaction| transaction.id}.join("<br />")
    else 
      active_scaffold_config.list.empty_field_text
    end
  end
  
  def business_column(record)
    if record.business
      record.business.name
    else
      active_scaffold_config.list.empty_field_text
    end
  end
end
