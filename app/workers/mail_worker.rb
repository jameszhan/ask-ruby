class MailWorker
  include Sidekiq::Worker

  def perform(method, resource_class, resource_id)
    resource = resource_class.classify.constantize.find(resource_id)
    Notifier.send(method.to_sym, resource)
  end
  
end