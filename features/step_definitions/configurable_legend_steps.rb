When /^I set the number of sample sizes to "([^"]*)" and the number of color swatches to "([^"]*)"$/ do |sample_sizes, color_swatches|
    click_link "Advanced \u00BB"
    fill_in 'Number of sizes in legend', :with => sample_sizes
    fill_in 'Number of colors in legend', :with => color_swatches
    click_button 'Update Geo graph'
end

When /^I set the number of sample sizes and color swatches to reasonable numbers$/ do
    @sample_sizes = 5
    @color_swatches = 5
    step %{I set the number of sample sizes to "#{@sample_sizes}" and the number of color swatches to "#{@color_swatches}"}
end

Then /^the legend should contain those numbers of sample sizes and color swatches$/ do
    page.should have_selector('#sizes .spot_size', :count => @sample_sizes)
    page.should have_selector('#colors .spot_color', :count => @color_swatches)
end

When /^I set the number of sample sizes to zero$/ do
    @sample_sizes = 0
    @color_swatches = 5
    step %{I set the number of sample sizes to "#{@sample_sizes}" and the number of color swatches to "#{@color_swatches}"}
end

Then /^the sample sizes area of the legend should not exist$/ do
    page.should have_no_selector('#sizes')
end

Then /^the color swatches area of the legend should still have the correct number of swatches$/ do
    page.should have_selector('#colors .spot_color', :count => @color_swatches)
end

When /^I set the number of color swatches to zero$/ do
    @sample_sizes = 5
    @color_swatches = 0
    step %{I set the number of sample sizes to "#{@sample_sizes}" and the number of color swatches to "#{@color_swatches}"}
end

Then /^the color swatches area of the legend should not exist$/ do
    page.should have_no_selector('#colors')
end

Then /^the sample sizes area of the legend should still have the correct number of sample sizes$/ do
    page.should have_selector('#sizes .spot_size', :count => @sample_sizes)
end

When /^I set the number of sample sizes and color swatches to zero$/ do
    @sample_sizes = 0
    @color_swatches = 0
    step %{I set the number of sample sizes to "#{@sample_sizes}" and the number of color swatches to "#{@color_swatches}"}
end

Then /^the legend should not exist$/ do
    page.should have_no_selector('#legend')
end

When /^I set the number of sample sizes or color swatches to a huge number$/ do
    @sample_sizes = 5000
    @color_swatches = 5000
    step %{I set the number of sample sizes to "#{@sample_sizes}" and the number of color swatches to "#{@color_swatches}"}
end

When /^I set the number of sample sizes or color swatches to a negative number$/ do
    @sample_sizes = -5
    @color_swatches = -5
    step %{I set the number of sample sizes to "#{@sample_sizes}" and the number of color swatches to "#{@color_swatches}"}
end

When /^I set the number of sample sizes or color swatches to a non\-integer value$/ do
    @sample_sizes = 'a'
    @color_swatches = 13.2
    step %{I set the number of sample sizes to "#{@sample_sizes}" and the number of color swatches to "#{@color_swatches}"}
end
