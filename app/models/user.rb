class User < Sequel::Model

  include SimpleAuth::Properties::Sequel
  include SimpleAuth::ModelMethods

  # Associations

  many_to_many :roles
  many_to_many :shows
  many_to_many :episodes

  def add_role(role)

    unless role.is_a?(Role)
      role = Role.where(:name => role.to_s).first
    end

    if role
      super role
      save
    end
  end

  def has_role?(role)
    roles.any?{|r|r.name == role.to_s}
  end

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
