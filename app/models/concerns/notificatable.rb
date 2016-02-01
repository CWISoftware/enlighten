module Notificatable
  extend ActiveSupport::Concern

  included do
    after_update do |entity|
      send_notification entity
    end
  end

  def send_notification(entity)
    NotificationJob.perform_later entity
  end
end
