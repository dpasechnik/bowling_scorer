class RecalculateGameScoreService
  attr_reader :game, :knocked_pins_number

  # @return [void]
  def initialize(game, knocked_pins_number)
    @game = game
    @knocked_pins_number = knocked_pins_number
  end

  # @return [void]
  def perform
    raise Error::IncorrectAttributeFormat, 'Incorrect format for `knocked_pins_number`, integer expected' unless knocked_pins_number.is_a? Integer
    raise Error::CompletedGameUpdateFailure, "Unable to update completed game id: #{game.id}" if game.completed?

    Frame.transaction do
      frame.assign_attributes(frame_attributes)
      frame.save!

      game_score = recalculated_scores.inject(0) { |m, score| m + score[:total] }

      recalculated_scores.each do |v|
        Frame.find(v[:id]).update!(total_score: v[:total])
      end

      game.update!(completed: completed?, total_score: game_score)
    end
  end

  private

  # @return [Integer]
  def bonus_score_for(frame)
    return 0 unless frame.spare? || frame.strike?

    index = frames.index(frame)
    next_frame = frames[index + 1]
    next_two_frames = [next_frame, frames[index + 2]]

    if frame.spare?
      next_frame&.first_roll_score
    elsif frame.strike?
      score_values = next_two_frames.map { |fr| [fr&.first_roll_score, fr&.second_roll_score] }.flatten
      score_values.compact.first(2).inject(&:+)
    end
  end

  # @return [Boolean]
  def completed?
    current_frame.last_in_game? && new_frame?
  end

  # @return [nil]
  # @return [Frame]
  def current_frame
    @current_frame ||= frames.last
  end

  # @return [Frame]
  def frame
    @frame ||= new_frame? ? Frame.new(frame_attributes) : current_frame
  end

  # @return [Frame::ActiveRecord_Associations_CollectionProxy]
  def frames
    @frames ||= game.frames
  end

  # @return [Hash]
  def frame_attributes
    frame_attributes = { game: game, **roll_attributes }
    new_frame? ? frame_attributes.merge(strike: strike?) : frame_attributes.merge(spare: spare?)
  end

  # @return [Boolean]
  def new_frame?
    return true if current_frame.blank?

    %w[needs_first_roll? needs_second_roll? needs_bonus_roll?].none? { |method| current_frame.public_send(method) }
  end

  # @return [Array]
  def recalculated_scores
    @recalculated_scores ||= begin
      frames.select(&:complete?).map { |frame| { id: frame.id, total: score_attributes_sum_for(frame) + bonus_score_for(frame).to_i } }
    end
  end

  # @return [Hash]
  def roll_attributes
    return { first_roll_score: knocked_pins_number } if new_frame?

    attr_name = Frame::SCORE_ATTRIBUTE_NAMES.detect { |attr| frame.public_send(attr).blank? }
    { attr_name.to_sym => knocked_pins_number }
  end

  # @return [Integer]
  def score_attributes_sum_for(frame)
    Frame::SCORE_ATTRIBUTE_NAMES.inject(0) { |m, attr| m + frame.public_send(attr).to_i }
  end

  # @return [Boolean]
  def spare?
    return true if current_frame&.spare?

    (current_frame&.first_roll_score.to_i + knocked_pins_number) == Frame::MAX_SCORE
  end

  # @return [Boolean]
  def strike?
    return true if current_frame&.strike?

    new_frame? && (knocked_pins_number == Frame::MAX_SCORE)
  end
end