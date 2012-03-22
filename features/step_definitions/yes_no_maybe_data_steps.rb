When /^I create a new datamap with a CSV that has yes\/no\/maybe data$/ do
    @datamap_name = 'Testing'
    step %{I create a new datamap named "#{@datamap_name}" with a CSV file named "#{File.dirname(__FILE__) + '/../upload_files/valid_yesnomaybe.csv'}"}
end

Then /^that datamap should contain yes\/no\/maybe data$/ do
    DataMap.find_by_name(@datamap_name).fields.yes_no.should_not be_empty
end

When /^I create a new datamap with an external data source that provides yes\/no\/maybe data$/ do
  pending # express the regexp above with the code you wish you had
end

