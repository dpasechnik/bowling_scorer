class Game < ApplicationRecord
  MAX_FRAMES = 10

  has_many :frames, -> { order(:id) }

  accepts_nested_attributes_for :frames

  def frames_attributes=(frame_attributes)
    RecalculateGameScoreService.new(self, frame_attributes['knocked_pins_count'])
  end
end
