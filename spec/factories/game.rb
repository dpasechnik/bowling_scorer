FactoryBot.define do
  factory :game do
    trait :completed do
      completed { true }
      total_score { 70 }

      after :create do |game|
        create_list(:frame, 10, first_roll_score: 3, second_roll_score: 4, game: game)
      end
    end

    trait :with_frames do
      after :create do |game|
        create_list(:frame, 5, game: game)
      end
    end
  end
end