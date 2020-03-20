class EntrySerializer < ActiveModel::Serializer
  attributes :id, :seed
  has_one :user
  has_one :bracket
end
