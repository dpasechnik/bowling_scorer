class Frame < ApplicationRecord
  MAX_SCORE = 10

  belongs_to :game

  acts_as_sequenced scope: :game_id
end
