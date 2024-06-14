class User < ApplicationRecord
  validates :name, presence: true
  validates :email, uniqueness: true
  
  after_create :send_create_notification
  after_update :send_update_notification
  
  def send_create_notification
    ThirdPartyNotifier.new('create', self).notify
  end
  
  def send_update_notification
    ThirdPartyNotifier.new('update', self).notify
  end
end
