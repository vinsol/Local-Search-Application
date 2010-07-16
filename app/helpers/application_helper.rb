# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def is_favorite(business)
    if business.business_relations.find(:first, :conditions => ["member_id = ? AND status = ?",session[:member_id],RELATION[:FAVORITE]])
      return true
    else
      return false
    end
  end
  
  def is_owner(business)
    if business.business_relations.find(:first, :conditions => ["member_id = ? AND status = ?",  
                                                                @member.id,RELATION[:OWNED]])
                                                               
      return true
    else
      return false
    end
  end
  
end
