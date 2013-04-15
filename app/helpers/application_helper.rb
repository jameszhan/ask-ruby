module ApplicationHelper

  def activity_users
    users = User.all.sort { |user1,user2| (user2.questions.count+user2.answers.count) <=> (user1.questions.count+user1.answers.count) }
    users.take(20)
  end

  def time_ago(datetime)
    time_ago_in_words(datetime) + " " + t("common.ago", default: "ago")
  end

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

  def hot_tags(tags)
    tags = tags.sort{ |tag1, tag2| tag2.question_count <=> tag1.question_count }
    tags.select{ |tag| tag.question_count > 0 }.take(20)
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
    args << I18n.locale
    args.unshift(name.parameterize, current_node.name, params[:controller], params[:action])
    args.join(":")
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
