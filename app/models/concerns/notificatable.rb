module Notificatable
  extend ActiveSupport::Concern

  included do
    after_update do |entity|
      NotificationJob.perform_later(entity)
    end
  end
end
