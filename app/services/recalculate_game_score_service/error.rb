
class RecalculateGameScoreService
  class Error < StandardError
    # Attempt to update finished game.
    class CompletedGameUpdateFailure < Error
    end
  end
end
