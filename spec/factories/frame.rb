FactoryBot.define do
  max_score = Frame::MAX_SCORE
  first_roll_score = 3

  factory :frame do
    transient do
      incomplete { false }
      with_bonus_roll { false }
    end

    first_roll_score { first_roll_score }

    after :build do |frame, evaluator|
      if evaluator.incomplete
        frame.second_roll_score = nil
      elsif frame.spare?
        frame.second_roll_score = max_score - first_roll_score
      elsif frame.strike?
        frame.first_roll_score = max_score
      end
    end

    trait :incomplete do
      incomplete { true }
    end

    trait :with_spare do
      spare { true }
    end

    trait :with_strike do
      strike { true }
    end

    trait :with_bonus_roll do
      with_spare
      bonus_roll_score { first_roll_score }
    end
  end
end