module Admin::SubCategoriesHelper
  def categories_column(record)
    if record.categories.any?
      record.categories.map {|category| category.category}.join("<br />")
    end
  end
  
 
  
end
