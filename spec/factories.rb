# frozen_string_literal: true

require "faker"

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    first_name { "Test" }
    second_name { "User" }
  end

  factory :project do
    title { Faker::Lorem.word }
    user { nil }
  end

  factory :tag do
    title { Faker::Lorem.word }
    user { nil }
  end

  factory :task do
    title { Faker::Lorem.word }
    description { Faker::Lorem.paragraph }
    is_done { false }
    project { nil }
    user { nil }
  end

  factory :tags_tasks, class: TagsTasks do
    tag { nil }
    task { nil }
  end
end
