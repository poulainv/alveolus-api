
# This will guess the WebApp class
FactoryGirl.define do
  factory :webapp do
    title                  "Rue89"
    caption                 "Site d'information"
    description            "Journal independant generalise"
   
    sequence(:url){|n| "http://www.#{n}lemonde.com" }
    validate true
    nb_click_preview 3
    nb_click_detail 3
    nb_click_url 3
  end
end

# This will guess the WebApp class
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
  association :user
  association :webapp
  end
end