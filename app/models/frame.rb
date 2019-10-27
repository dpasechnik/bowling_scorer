class Frame < ApplicationRecord
  MAX_SCORE = 10
  SCORE_ATTRIBUTE_NAMES = %w[first_roll_score second_roll_score bonus_roll_score].freeze

  belongs_to :game

  acts_as_sequenced scope: :game_id

  validate :sum_of_scores_within_range

  # @return [Boolean]
  def complete?
    !needs_first_roll? && !needs_second_roll? && !needs_bonus_roll?
  end

  # @return [Boolean]
  def last_in_game?
    sequential_id == Game::MAX_FRAMES
  end

  # @return [Boolean]
  def needs_bonus_roll?
    bonus_roll_score.nil? && spare_or_strike? && last_in_game? && !needs_second_roll?
  end

  # @return [Boolean]
  def needs_first_roll?
    first_roll_score.nil?
  end

  # @return [Boolean]
  def needs_second_roll?
    second_roll_score.nil? && !strike? && !needs_first_roll?
  end

  # @return [Integer]
  def rolls_sum
    SCORE_ATTRIBUTE_NAMES.inject(0) { |m, attr| m + public_send(attr).to_i }
  end

  # @return [Boolean]
  def spare_or_strike?
    strike? || spare?
  end

  private

  # @return [Boolean]
  def sum_of_scores_within_range
    set_sequential_ids

    changed_attributes = changed & SCORE_ATTRIBUTE_NAMES
    max_score_range = (0..MAX_SCORE)

    if last_in_game?
      if spare?
        max_score_range = MAX_SCORE..(MAX_SCORE * 2)
      elsif strike?
        max_score_range = MAX_SCORE..(MAX_SCORE * 3)
      end
    end

    is_within_range = rolls_sum.in?(max_score_range.to_a)

    return true if changed_attributes.blank? || is_within_range

    errors.add(changed_attributes.last, "should be integer within #{max_score_range} range")
    false
  end
end
