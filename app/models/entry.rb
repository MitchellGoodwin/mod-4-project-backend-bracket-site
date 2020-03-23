class Entry < ApplicationRecord
  belongs_to :user
  belongs_to :bracket

  validates_uniqueness_of :bracket_id, :scope => :user_id

  def update_seeds_for_delete
    other_entries = self.bracket.entries.select{|entry| entry.seed > self.seed}
    other_entries.each{|entry| entry.update(seed: entry.seed - 1)}
  end
end
