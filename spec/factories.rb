
FactoryGirl.define do
  factory :category do
    id                1
    name              'Crowdfunding'
  end
end

# This will guess the WebApp class
FactoryGirl.define do
  factory :webapp do
    title             "Babyloan"
    category_id       1
    caption           "Le site des microcredits solidaires. C\'est une nouvelle forme de solidarite par le Pret, qui permet a des micro-entrepreneurs de sortir de la precarite grace au fruit de leur travail."
    description       "Babyloan est le premier site Europeen de microcredits solidaires C\'est une nouvelle forme de solidarite par le Pret, qui permet a des micro-entrepreneurs de sortir de la precarite grace au fruit de leur travail."
    sequence(:url)    {|n| "http://www.#{n}babyloan.org" }
    validate          true
    nb_click_preview  23
    nb_click_detail   43
    nb_click_url      13
    average_rate      0

    trait :with_comments do
      after (:create) do |instance|
        create_list(:comment, 2, webapp: instance)
      end
    end

  end
end

FactoryGirl.define do
  factory :tag do
    name                  "tag1"
  end
end

# This will guess the User
FactoryGirl.define do
  factory :user do
    sequence(:email){|n| "vincent.poulain#{n}@lemonde.com" }
    password  "saluttoi"
  end
end

FactoryGirl.define do
  factory :comment do
  body "Foo bar"
  rating 2
  association :user
  association :webapp
  end
end