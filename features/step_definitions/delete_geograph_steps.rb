When /^I delete my geograph$/ do
    visit root_path
    click_link 'Delete'
end

When /^I attempt to delete someone else's geograph$/ do
    visit geo_graph_path(1, :method => :delete)
end

Then /^my geograph should no longer exist$/ do
    GeoGraph.find_by_name(@geograph_name).should be_nil
end
