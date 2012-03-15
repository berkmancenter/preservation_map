When /^I create a new geograph with a CSV that has yes\/no\/maybe data$/ do
    @geograph_name = 'Testing'
    step %{I create a new geograph named "#{@geograph_name}" with a CSV file named "#{File.dirname(__FILE__) + '/../upload_files/valid_yesnomaybe.csv'}"}
end

Then /^that geograph should contain yes\/no\/maybe data$/ do
    GeoGraph.find_by_name(@geograph_name).measures.yes_no.should_not be_empty
end

When /^I create a new geograph with an external data source that provides yes\/no\/maybe data$/ do
  pending # express the regexp above with the code you wish you had
end

