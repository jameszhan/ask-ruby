module ApplicationHelper
  class HTMLwithCodeRay < Redcarpet::Render::HTML
    def block_code(code, language)
      sha = Digest::SHA1.hexdigest(code)
      Rails.cache.fetch ["code", language, sha].join("-") do
        CodeRay.scan(code, language).div(:line_numbers => :table)
      end
    end
  end
  
  def markdown(text)
    return "" unless text
    renderer = HTMLwithCodeRay.new(hard_wrap: true, filter_html: true)
    options = {
      autolink: true,
      no_intra_emphasis: true,
      fenced_code_blocks: true,
      lax_html_blocks: true,
      strikethrough: true,
      superscript: true
    }
    result = Redcarpet::Markdown.new(renderer, options).render(text)
    MdEmoji::Render.new.replace_emoji(result).html_safe    
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
  
  def tag_list
    current_node.tags.map(&:id)
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

end
