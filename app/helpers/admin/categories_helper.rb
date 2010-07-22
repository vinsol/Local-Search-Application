module Admin::CategoriesHelper
  def sub_categories_column(record)
    if record.sub_categories.any?
      record.sub_categories.map {|sub_category| sub_category.sub_category}.join("<br />")
    end
  end
end
