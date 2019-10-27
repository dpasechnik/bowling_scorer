
class RecalculateGameScoreService
  class Error < StandardError
    # Attempt to update finished game.
    class CompletedGameUpdateFailure < Error
    end

    class IncorrectAttributeFormat < Error
    end
  end
end
