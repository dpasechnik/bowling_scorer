class GameBlueprint < Blueprinter::Base
  identifier :id

  fields :id, :completed, :name, :total_score
  association :frames, blueprint: FrameBlueprint
end