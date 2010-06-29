module Admin::MembersHelper
  def is_admin_column(record)
    record.is_admin
  end
end
