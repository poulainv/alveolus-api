

Given /^I have webapps titled (.+)$/ do |titles|
  titles.split(', ').each do |title|
    Webapp.create!(:title => title, :caption => "test", :description => "test", :url => "www.#{title}.  fr", :validate => '1') 
  end
end

Given /^I am on the homepage$/ do
  visit accueil_path
end

Given /^I should see (.+)$/ do |text|
  page.should have_content(:text => text)
end