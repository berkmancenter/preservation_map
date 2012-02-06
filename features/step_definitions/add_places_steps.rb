Given /^I am on the "([^"]*)" page for my geograph$/ do |path|
    visit send("geo_graph_#{path.gsub(' ', '_')}_path", @user.geo_graphs.first)
end

When /^I upload a valid CSV file$/ do
    attach_file("Places Data", File.dirname(__FILE__) + '/../../../library.csv')
    click_button('Update Geo graph')
end

Then /^my geograph should now contain the places$/ do
  pending # express the regexp above with the code you wish you had
end

