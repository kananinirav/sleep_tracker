FactoryBot.define do
  factory :sleep_tracking do
    clock_in { Time.zone.now }
    clock_out { Time.zone.now + (1..5).to_a.sample.days }
    sleep_duration { clock_out.present? ? clock_out - clock_in : nil }
    user
  end
end
