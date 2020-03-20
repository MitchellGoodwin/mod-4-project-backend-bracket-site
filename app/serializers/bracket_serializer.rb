class BracketSerializer < ActiveModel::Serializer
  attributes :id, :name, :desc, :status
  has_one :admin
end
