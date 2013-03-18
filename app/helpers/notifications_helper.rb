module NotificationsHelper
	def get_instance(item)
		item.source.classify.constantize.find(item.source_id)
	end
end
