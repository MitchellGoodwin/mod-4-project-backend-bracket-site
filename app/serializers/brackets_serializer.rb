class BracketsSerializer < ActiveModel::Serializer
    attributes :id, :name, :desc, :status
    has_one :user
  end