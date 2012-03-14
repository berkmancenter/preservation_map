When /^I create a new geograph with a CSV that has yes\/no\/maybe data$/ do
    step %{I create a new geograph named "Testing" with a CSV file named "#{File.dirname(__FILE__) + '/../upload_files/valid_yesnomaybe.csv'}"}
end

When /^I create a new geograph with an external data source that provides yes\/no\/maybe data$/ do
  pending # express the regexp above with the code you wish you had
end

