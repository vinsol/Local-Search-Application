module Admin::SubCategoriesHelper
  def categories_column(record)
    if record.categories.any?
      record.categories.map {|category| category.category}.join("<br />")
    else 
      active_scaffold_config.list.empty_field_text
    end
  end
  
 
  
end
