class V1::GamesController < ApplicationController

  def create
    game = Game.create(game_parameters)

    render_game(game)
  end

  def show
    render_game(game)
  end

  def update
    game.update(frames_attributes: frame_parameters)

    render_game(game.reload)
  end

  protected

  def frame_parameters
    params.require(:frame).permit(:knocked_pins_count)
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
