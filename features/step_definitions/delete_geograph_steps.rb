When /^I delete my datamap$/ do
    visit root_path
    click_link 'Delete'
end

When /^I attempt to delete someone else's datamap$/ do
    visit data_map_path(1, :method => :delete)
end

Then /^my datamap should no longer exist$/ do
    DataMap.find_by_name(@datamap_name).should be_nil
end
