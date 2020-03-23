class EntrySerializer < ActiveModel::Serializer
  attributes :id, :seed
  belongs_to :user, serializer: UserSerializer
  has_one :bracket
end
