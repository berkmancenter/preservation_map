When /^I set the minimum spot size to "([^"]*)" and the maximum spot size to "([^"]*)"$/ do |minimum, maximum|
    click_link "Advanced \u00BB"
    fill_in 'Minimum spot size', :with => minimum
    fill_in 'Maximum spot size', :with => maximum
    click_button 'Update DataMap'
end

When /^I set the minimum and maximum spot sizes to reasonable numbers$/ do
    @minimum = 5
    @maximum = 20
    step %{I set the minimum spot size to "#{@minimum}" and the maximum spot size to "#{@maximum}"}
end

Then /^the minimum and maximum spot sizes should be those numbers$/ do
    page.should have_selector(%{.spot_circle[style="width:#{@minimum * 2 - 2}px;height:#{@minimum * 2 - 2}px;"]})
    page.should have_selector(%{.spot_circle[style="width:#{@maximum * 2 - 2}px;height:#{@maximum * 2 - 2}px;"]})
end

When /^I set the minimum or maximum spot sizes to huge numbers$/ do
    step %{I set the minimum spot size to "2000" and the maximum spot size to "2000"}
end

When /^I set the minimum and maximum spot sizes to zero$/ do
    step %{I set the minimum spot size to "0" and the maximum spot size to "0"}
end

When /^I set the minimum spot size to a value larger than the maximum spot size$/ do
    @minimum = 20
    @maximum = 5
    step %{I set the minimum spot size to "#{@minimum}" and the maximum spot size to "#{@maximum}"}
end

Then /^spots with greater values should be smaller than spots with lesser values$/ do
    # This is confusing.  It takes the size of the first sample spot in the legend and compares it to the last
    page.find(%{.spot_size:nth-child(2) .spot_circle})[:style].match(/width: (\d*)px/)[1].to_i.should > page.find(%{.spot_size:last-child .spot_circle})[:style].match(/width: (\d*)px/)[1].to_i
end

When /^I set the minimum or maximum spot size to a negative number$/ do
    step %{I set the minimum spot size to "-20" and the maximum spot size to "-5"}
end

When /^I set the minimum or maximum spot size to a non\-integer value$/ do
    step %{I set the minimum spot size to "a" and the maximum spot size to "13.2"}
end
