class FrameBlueprint < Blueprinter::Base
  identifier :id

  fields :strike, :spare, :bonus_roll_score, :first_roll_score, :second_roll_score, :total_score
end