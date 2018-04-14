require 'rails_helper'

RSpec.describe ReportBuilder do
  let(:data_one) { OpenStruct.new(first_name: "Alex", last_name: "Khlipun") }
  let(:data_two) { OpenStruct.new(first_name: "Noel", last_name: "Rappin") }
  let(:builder) { ReportBuilder.new do
                    column(:first_name)
                    column(:last_name)
                  end }
  
  it "converts data into an array of hashes" do
    result = builder.build([data_one, data_two])
    
    expect(result).to eq(
      [{"First name" => "Alex", "Last name" => "Khlipun"},
       {"First name" => "Noel", "Last name" => "Rappin"}])
  end
  
  it "converts data into an array of hashes without friendly names" do
    builder.humanize_name = false
    result = builder.build([data_one, data_two])
    
    expect(result).to eq(
      [{"first_name" => "Alex", "last_name" => "Khlipun"},
       {"first_name" => "Noel", "last_name" => "Rappin"}])
  end
  
  it "handles CSV" do
    result = builder.build([data_one, data_two], format: :csv)
    
    expect(result).to eq("First name,Last name\nAlex,Khlipun\nNoel,Rappin\n")
  end
end