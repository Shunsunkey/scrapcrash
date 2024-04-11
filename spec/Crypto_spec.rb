require_relative '../lib/Crypto.rb'

RSpec.describe "#total_pages" do
  it "returns the total number of pages" do
    url = "https://coinmarketcap.com/all/views/all/"
    expect(total_pages(url)).to be_kind_of(Integer)
  end
end

RSpec.describe "#scrape_coinmarketcap" do
  it "returns an array of crypto data" do
    expect(scrape_coinmarketcap).to be_kind_of(Array)
  end
end
