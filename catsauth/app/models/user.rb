# == Schema Information
#
# Table name: users
#
#  id              :bigint(8)        not null, primary key
#  user_name       :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord
    validates :user_name, :password_digest, :session_token, presence: true
    validates :user_name, :session_token, uniqueness: true
    attr_reader :password

    validates :password, length: {minimum: 6, allow_nil: true}

    after_initialize :create_session_token

    has_many :cat_rental_requests,
    foreign_key: :user_id,
    class_name: :CatRentalRequest

    has_many :cats,
        foreign_key: :user_id,
        class_name: :Cat

    def create_session_token
        self.session_token ||= SecureRandom::urlsafe_base64
    end

    def reset_session_token!
        self.session_token = SecureRandom::urlsafe_base64
        self.save!
    end

    def password=(password)
        @password = password
        self.password_digest = BCrypt::Password.create(@password)
    end

    def is_password?(password)
        BCrypt::Password.new(self.password_digest).is_password?(password)
    end

    def self.find_by_credentials(username1, password1)
        user = User.find_by(user_name: username1)
        if user
            return user if user.is_password?(password1) 
        end
        nil
    end

end