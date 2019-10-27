require 'rails_helper'

RSpec.describe RecalculateGameScoreService do
  let(:game) { create :game }
  let(:knocked_pins_number) { 1 }

  let(:instance) { described_class.new(game, knocked_pins_number) }

  describe '#perform' do
    subject { instance.perform }

    context 'when error' do
      context 'when game is completed' do
        let(:game) { create :game, :completed }

        it 'raises an exception' do
          expect { subject }.to raise_error(described_class::Error::CompletedGameUpdateFailure, /Unable to update completed game id: #{game.id}/)
        end
      end

      context 'when `knocked_pins_count` is not integer' do
        let(:knocked_pins_number) { "1" }

        it 'raises an exception' do
          expect { subject }.to raise_error(described_class::Error::IncorrectAttributeFormat, /Incorrect format for `knocked_pins_number`, integer expected/)
        end
      end

      context 'when game is incomplete' do
        let!(:frame) { create :frame, :incomplete, game: game }

        it 'reverts changes in case error during processing' do
          expect(game).to receive(:update!)
            .with(completed: false, total_score: 4)
            .and_raise(ActiveRecord::RecordInvalid)

          expect { subject }.to raise_error(ActiveRecord::RecordInvalid)

          expect(game.frames.count).to eq 1
        end
      end
    end

    context 'when success' do
      let(:incomplete_frame) { create :frame, :incomplete, game: game }

      it 'generally works' do
        expect { subject }.to change { incomplete_frame.reload.second_roll_score }.from(nil).to(1)
        expect(game.total_score).to eq(4)
      end

      context 'when edge cases' do
        context 'when last frame' do
          let!(:frames) { create_list :frame, 9, :with_spare, game: game }

          def call(pins_number = knocked_pins_number)
            described_class.new(game, pins_number).perform
          end

          context 'when spare' do
            let!(:last_frame) { create :frame, first_roll_score: 1, game: game }

            it 'allows to make a bonus roll' do
              call(9)
              expect(game.total_score).to eq 115

              expect { call(5) }.to change { game.reload.total_score }.from(115).to(130)
            end
          end

          context 'when strike' do
            let!(:last_frame) { create :frame, :with_strike, game: game }

            it 'allows to make 2 additional rolls' do
              call(5)
              expect(game.total_score).to eq 124

              expect { call(4) }.to change { game.reload.total_score }.from(124).to(143)
            end
          end
        end

        context 'when spare + strike' do
          let!(:frame) { create :frame, :with_spare, game: game }
          let(:knocked_pins_number) { 10 }

          it do
            expect { subject }.to change { game.total_score }.from(nil).to(30)
            expect(game.frames.count).to eq 2
          end
        end
      end
    end
  end
end