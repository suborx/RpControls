FactoryGirl.define do

  factory :branch do
    name 'Bratislava'
    mark 'BA'
  end

  factory :user do
    association :branch
    is_active true
    first_name 'John'
    last_name  'Doe'
    phone '0909123123'
    email 'admin@admin.sk'
    password 'heslo123'
    password_confirmation 'heslo123'

    factory(:admin){ is_admin true }

  end

end
