class V1::GamesController < ApplicationController

  def create
    @game = Game.create(game_parameters)
  end

  def show
    game
  end

  def update
    game.update(frames_attributes: frame_parameters)
  end

  protected

  def frame_parameters
    params.require(:frame).permit(:knocked_pins_count)
  end

  def game_parameters
    params.require(:game).permit(:name)
  end

  def game
    @game ||= Game.find(params[:id])
  end
end
