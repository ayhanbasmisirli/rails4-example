class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable, :confirmable, :lockable, :timeoutable,
         :recoverable, :rememberable, :trackable, :validatable #, :omniauthable

  validates :username, :uniqueness => true, :length => { :within => 4..12 }
  
  ROLES = { 'guest' => 1, 'user' => 2, 'manager' => 3, 'admin' => 4 }

  def roles
    ROLES
  end

  def role?(base_role)
    ROLES[role.to_s] >= ROLES[base_role.to_s.downcase]
  end

  def is_role?(test_role)
    role == test_role
  end

  def user_exists_but_force_password_reset?
    (id && confirmed_at.present? && reset_password_token.present? && last_sign_in_at.blank? && last_sign_in_ip.blank?) ? true : false
  end

  def log_devise_action(new_action)
    DeviseUsageLog.create ({user_id: id, role: role, user_ip: current_sign_in_ip, username: username, action: new_action})
  end
end
