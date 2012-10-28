
# This will guess the WebApp class
FactoryGirl.define do
  factory :webapp do
    title                  "Rue89"
    caption                 "Site d'information"
    description            "Journal independant generalise"
    url      "www.rue89.fr"
    validate true
  end
end