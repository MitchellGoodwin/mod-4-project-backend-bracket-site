class User < ApplicationRecord
    has_secure_password
    validates :username, uniqueness: { case_sensitive: false }
    validates :username, :email, presence: true
    validates :email, uniqueness: { case_sensitive: false }

    has_many :brackets

    has_many :entries
    has_many :tournaments, through: :entries, :source => :bracket
end
