Given /^I am an admin$/ do
end

When /^I create a valid geograph named "([^"]*)"$/ do |geograph_name|
    GeoGraph.new(:name => geograph_name)
end

Then /^I should be redirected to the measure\-adding page for "([^"]*)"$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

