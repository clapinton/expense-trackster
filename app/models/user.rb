# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  is_admin        :boolean          not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ActiveRecord::Base

  validates :email, :password_digest, :session_token, presence: true
  validates :is_admin, inclusion: { in: [ true, false ] }
  validates :email, :session_token, uniqueness: true;
  validates :password, length: {minimum: 6}

  after_initialize :ensure_session_token

  attr_reader :password

  def generate_session_token
    SecureRandom.urlsafe_base64(16)
  end

  def ensure_session_token
    self.session_token ||= self.generate_session_token
  end

  def reset_session_token
    self.session_token = self.generate_session_token
  end  

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def bcrypt_pwd
    BCrypt::Password.new(self.password_digest)
  end

  def self.find_by_credentials(email, password)
    user = User.find_by(email: email)
    return nil unless user
    user.bcrypt_pwd.is_password?(password) ? user : nil
  end  

end
