When /^I change the map center$/ do
    page.find('#map').native.send_keys :arrow_left, :arrow_up
end

When /^I change the map zoom$/ do
    page.find('#map').native.send_keys :add, :add, :add, :add
end

When /^I change the color theme$/ do
    page.choose 'data_map_color_theme_id_4'
end

When /^I change the size criteria$/ do
    page.select 'Continuum', :from => 'Size measure'
end

When /^I change the color criteria$/ do
    page.select 'Constant', :from => 'Color measure'
end

When /^I set the default view$/ do
    click_link 'Set as default view'
end

Then /^the map center should be the same$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^the map zoom should be the same$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^color theme should be the same$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^the size criteria should be the same$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^the color criteria should be the same$/ do
  pending # express the regexp above with the code you wish you had
end
