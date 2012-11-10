
# This will guess the WebApp class
FactoryGirl.define do
  factory :webapp do
    title                  "Rue89"
    caption                 "Site d'information"
    description            "Journal independant generalise"
    url      "www.rue89.fr"
    validate true
    nb_click_preview 3
  end
end

# This will guess the WebApp class
FactoryGirl.define do
  factory :tag do
    name                  "tag1"
  end
end