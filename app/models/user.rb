class User < Sequel::Model

  include SimpleAuth::Properties::Sequel
  include SimpleAuth::ModelMethods

  # Associations

  many_to_many :roles
  many_to_many :shows
  many_to_many :watched_episodes, :join_table => :watched_shows_users

protected

  # Validations

  def validate
    simple_auth_validate
    super
  end

  # Hooks

  def before_save
    simple_auth_before_save
    super
  end

end
