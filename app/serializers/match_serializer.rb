class MatchSerializer < ActiveModel::Serializer
  attributes :id, :round, :set
  has_one :user_one
  has_one :user_two
  has_one :bracket
  has_one :winner
end
