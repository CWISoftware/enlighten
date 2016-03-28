# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime
#  updated_at             :datetime
#  remember_token         :string
#

class User < ActiveRecord::Base
  include ::Authenticatable

  before_create :creates_person_to_ldap_authentication, :assigns_default_permission_roles

  has_one :person

  has_and_belongs_to_many :followed_projects,
                          class_name: Project.name,
                          join_table: :users_following_projects

  has_and_belongs_to_many :followed_technologies,
                          class_name: Technology.name,
                          join_table: :users_following_technologies

  has_and_belongs_to_many :followed_clients,
                          class_name: Client.name,
                          join_table: :users_following_clients

  has_and_belongs_to_many :followed_people,
                          class_name: Person.name,
                          join_table: :users_following_people

  has_and_belongs_to_many :followed_cards,
                          class_name: Card.name,
                          join_table: :users_following_cards

  has_and_belongs_to_many :liked_projects,
                          class_name: Project.name,
                          join_table: :users_liking_projects

  has_and_belongs_to_many :liked_technologies,
                          class_name: Technology.name,
                          join_table: :users_liking_technologies

  has_and_belongs_to_many :liked_clients,
                          class_name: Client.name,
                          join_table: :users_liking_clients

  has_and_belongs_to_many :liked_people,
                          class_name: Person.name,
                          join_table: :users_liking_people

  has_and_belongs_to_many :liked_cards,
                          class_name: Card.name,
                          join_table: :users_liking_cards

  has_and_belongs_to_many :permission_roles,
                          class_name: Permission::Role.name,
                          join_table: :users_permission_roles,
                          association_foreign_key: 'permission_role_id'

  private

  def ldap_attribute(attribute)
    Devise::LDAP::Adapter.get_ldap_param(email, attribute)
  end

  def ldap_attribute_name
    ldap_attribute('displayName').nil? ? email : ldap_attribute('displayName').first
  end

  def ldap_attribute_image
    if ldap_attribute('thumbnailPhoto').nil?
      Gravatar.new(email).image_data
    else
      StringIO.new(ldap_attribute('thumbnailPhoto').first)
    end
  end

  def creates_person_to_ldap_authentication
    return unless LDAP.enabled?
    self.person = Person.create(name: ldap_attribute_name, image: ldap_attribute_image)
  end

  def assigns_default_permission_roles
    Permission::Role.where(default: true).each do |permission_role|
      permission_roles << permission_role
    end
  end

  def password_digest(decrypted_password)
    Devise::Encryptor.digest(self.class, decrypted_password)
  end
end
