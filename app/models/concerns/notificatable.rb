module Notificatable
  extend ActiveSupport::Concern

  included do
    after_update :send_notification, if: :changed?
  end

  def send_notification
    NotificationJob.perform_later self
  end
end
