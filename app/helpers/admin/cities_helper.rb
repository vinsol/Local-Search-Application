module Admin::CitiesHelper
  
  
  
  def locations_column(record)
    if record.locations.any?
      p record.locations
      record.locations.map {|location| location.location}.join("<br />")
    else 
      active_scaffold_config.list.empty_field_text
    end
  end
  
end
