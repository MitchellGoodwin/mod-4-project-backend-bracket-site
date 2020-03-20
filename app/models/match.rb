class Match < ApplicationRecord
  belongs_to :user_one ,:class_name=>'User', optional: true
  belongs_to :user_two ,:class_name=>'User', optional: true
  belongs_to :bracket
  belongs_to :winner ,:class_name=>'User', optional: true
end
