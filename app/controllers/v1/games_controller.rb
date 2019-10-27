class V1::GamesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_record_not_found

  def create
    game = Game.create(game_parameters)

    if game.persisted?
      render_game(game)
    else
      render json: { errors: game.errors.full_messages.join(' ,') }, status: :bad_request
    end
  end

  def show
    render_game(game)
  end

  def update
    service = RecalculateGameScoreService

    begin
      service.new(game, params[:knocked_pins_count]).perform
      render_game(game.reload)
    rescue service::Error::IncorrectAttributeFormat => e
      render json: { errors: e.message }, status: :bad_request
    rescue service::Error::CompletedGameUpdateFailure => e
      render json: { errors: e.message }, status: :conflict
    end
  end

  protected

  def render_record_not_found(error)
    render json: { errors: error.message }, status: :not_found
  end

  def game
    @game ||= Game.find(params[:id])
  end

  def game_parameters
    params.require(:game).permit(:name)
  end

  def render_game(game)
    render json: GameBlueprint.render(game)
  end
end
