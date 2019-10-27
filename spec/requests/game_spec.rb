describe 'Game', type: :request do

  let(:completed_game) { create :game, :completed }
  let(:game) { create :game }

  describe 'existing game' do
    context 'when error' do
      it 'returns 404 in case game wasn\'t found' do
        get v1_game_path, params: { id: 666 }

        expect(response.status).to eq 404
        expect(JSON.parse(response.body)['errors']).to match(/^Couldn't find Game with 'id'=666$/)
      end
    end

    context 'when success' do
      it 'allows to get the result of existing game' do
        get v1_game_path, params: { id: completed_game.id }

        expect(response.status).to eq 200
        body = JSON.parse(response.body)

        expect(body['frames'].count).to eq 10
        expect(body['total_score']).to eq 70
      end
    end
  end

  describe 'new game' do
    context 'when error' do
      it 'returns 400 with error message' do
        post v1_game_path, params: { game: { name: 'Super game' * 166 } }

        expect(response.status).to eq 400
        expect(JSON.parse(response.body)['errors']).to match(/^Name is too long/)
      end
    end

    context 'when success' do
      it 'allows to start a new game' do
        post v1_game_path, params: { game: { name: 'Super game' } }

        expect(response.status).to eq 200
        expect(JSON.parse(response.body)['name']).to eq 'Super game'
      end
    end
  end

  describe 'update game' do
    context 'when error' do
      context 'when 400' do
        it 'returns correct status and error message in case `knocked_pins_count` is not integer' do
          put v1_game_path, params: { id: game.id, knocked_pins_count: '3' }, as: :json

          expect(response.status).to eq 400
          expect(JSON.parse(response.body)['errors']).to match(/^Incorrect format for `knocked_pins_number`, integer expected$/)
        end
      end

      context 'when 404' do
        it 'returns correct status and error message in case game wasn\'t found' do
          put v1_game_path, params: { id: 666 }

          expect(response.status).to eq 404
          expect(JSON.parse(response.body)['errors']).to match(/^Couldn't find Game with 'id'=666$/)
        end
      end

      context 'when 409' do
        it 'returns correct status and error message in case game is already completed' do
          put v1_game_path, params: { id: completed_game.id, knocked_pins_count: 3 }, as: :json

          expect(response.status).to eq 409
          expect(JSON.parse(response.body)['errors']).to match(/^Unable to update completed game id: #{completed_game.id}$/)
        end
      end
    end

    context 'when success' do
      it do
        put v1_game_path, params: { id: game.id, knocked_pins_count: 3 }, as: :json

        expect(response.status).to eq 200
      end
    end
  end
end