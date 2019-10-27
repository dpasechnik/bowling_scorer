FactoryBot.define do
  factory :game do
    trait :completed do
      completed { true }

      after :create do |game|
        create_list(:frame, 9, game: game)
        create(:frame, :with_bonus_roll, game: game)
      end
    end

    trait :with_frames do
      after :create do |game|
        create_list(:frame, 5, game: game)
      end
    end
  end
end