module NotificationsHelper
  def get_instance(item)
    item.source_type.classify.constantize.find(item.source_id)
  rescue
    nil
  end
end
