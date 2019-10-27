class Game < ApplicationRecord
  MAX_FRAMES = 10

  validates :name, length: { minimum: 1, maximum: 150 }, allow_blank: true

  has_many :frames, -> { order(:sequential_id) }

  accepts_nested_attributes_for :frames
end
