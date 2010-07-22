module Admin::CitiesHelper
  
  def locations_column(record)
    if record.locations.any?
      record.locations.map {|location| location.location}.join("<br />")
    end
  end
  
end
