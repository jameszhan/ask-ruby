module SessionFilter
  extend ActiveSupport::Concern

  included do
    before_filter :set_current_tags
    before_filter :set_current_order
    helper_method :current_tags, :current_order
  end
  
  def current_tags
    @current_tags
  end
  
  def current_order
    @current_order
  end

  def set_current_tags
    tag_param = params[:tags] || session[:tags]
    if tag_param.kind_of?(String)
      if tag_param =~ /^tags\:([^\s]+)$/
        @current_tags = $1.split("+") unless $1.empty?
        session[:tags] = tag_param if params[:tags]
      else
        @current_tags = []
        session.delete :tags
      end
    elsif tag_param.kind_of?(Array)
      @current_tags = tag_param
    else
      @current_tags = []
    end  
  end
  
  def set_current_order
    if respond_to?(:hook_current_order)
      send(:hook_current_order)
    end
  end

  
  module ClassMethods
    def order_tabs(order_tabs)
      #order_tabs = order_tabs.symbolize_keys!
      define_method :hook_current_order do
        order = params[:order] || session[:order] 
        if order
          order_tab = order_tabs[params[:action].to_sym]
          if order_tab
            session[:order] = params[:order] if params[:order]          
            @current_order = order_tab[order.to_sym]
          else
            @current_order = order_tabs.first.first
          end      
        else
          order_tab = order_tabs[params[:action].to_sym]
          @current_order = order_tab.first.last if order_tab          
        end     
      end      
    end
  end
   
end