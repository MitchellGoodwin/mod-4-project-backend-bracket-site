class BracketSerializer < ActiveModel::Serializer
  attributes :id, :name, :desc, :status
  has_one :user
  has_many :entries, serializer: EntrySerializer
  has_many :matches
end
