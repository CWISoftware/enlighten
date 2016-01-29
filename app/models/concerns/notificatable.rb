module Notificatable
  extend ActiveSupport::Concern

  included do
    after_update do |entity|
      NotificationMailer.notification_email(entity).deliver_later
    end
  end
end
