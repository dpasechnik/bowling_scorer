class Game < ApplicationRecord
  MAX_FRAMES = 10

  has_many :frames, -> { order(:id) }

  accepts_nested_attributes_for :frames

  def frames_attributes=(frame_attributes)
    #TODO: add logic to handle frame attributes.
  end
end
