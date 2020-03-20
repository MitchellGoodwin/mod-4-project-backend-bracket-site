class Entry < ApplicationRecord
  belongs_to :user
  belongs_to :bracket

  validates_uniqueness_of :bracket_id, :scope => :user_id
end
