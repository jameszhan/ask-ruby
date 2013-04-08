module ApplicationHelper
  
  def tagged_with_questions_path(tag, remove = false)
    path = questions_path + "/tags:" 
    unless remove
      path += (current_tags | [tag]).join("+") 
    else
      path += (current_tags - [tag]).join("+")
    end
    path
  end
  
  def tag_name(tag_id)
    begin
      current_node.tags.find(tag_id).name
    rescue
      tag_id
    end
  end
  
  def tag_list
    @tag_list ||= current_node.tags.map{|tag| [tag.name, tag.id]}
  end
  
  def find_widgets(position)
    current_node.lookup_widgets(:default, position)
  end
  
  def cache_for(name, *args, &block)
    cache(cache_key_for(name, *args), &block)
  end

  def cache_key_for(name, *args)
    args.unshift(name.parameterize, current_node.id, params[:controller], params[:action], I18n.locale)
    args.join("_")
  end
  
  def render_widget(widget)
    if widget.accept? params
      render partial: widget.partial_name, locals: {widget: widget}
    end
  end

  def unread_count(notifications)
    unread_notifications = []
    notifications.each do |notification|
      unless notification.read
        unread_notifications << notification
      end
    end
    unread_notifications.count
  end

end
