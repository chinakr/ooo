require 'digest/sha2'

class User < ActiveRecord::Base
  validates :username, presence: true, uniqueness: true
  validates :name, presence: true
  validates :email, presence: true
  validates :mobile, presence: true
  
  validates :password, confirmation: true
  attr_reader :password
  attr_accessor :password_confirmation
  validate :password_must_be_present
  
  def User.encrypt_password(password, salt)
    Digest::SHA2.hexdigest(password + '123abc' + salt)
  end

  def User.authenticate(username, password)
    if user = find_by_username(username)
      if user.hashed_password == encrypt_password(password, user.salt)
        user
      end
    end
  end

  def password=(password)
    @password = password
    if password.present?
      generate_salt
      self.hashed_password = self.class.encrypt_password(password, self.salt)
    end
  end

  private
    
    def password_must_be_present
      errors.add(:password, t('.password_cannot_be_blank')) unless hashed_password.present?
    end

    def generate_salt
      self.salt = self.object_id.to_s + rand.to_s
    end

end
