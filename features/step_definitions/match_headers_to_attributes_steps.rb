When /^I upload a CSV file containing places and measures with specific header fields$/ do
    attach_file("Import data", File.dirname(__FILE__) + '/../../../library2.csv')
    click_button('Create Geo graph')
end

Then /^the "([^"]*)" geograph should contain places$/ do |geograph_name|
    GeoGraph.find_by_name(geograph_name).places.count.should be > 0
end
