class MailWorker
  include Sidekiq::Worker

  def perform(name, resource_class, id)
    resource = resource_class.constantize.find(id)
    Notifier.try(name, resource).deliver
  end
  
end