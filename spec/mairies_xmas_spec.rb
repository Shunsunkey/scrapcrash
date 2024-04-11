require_relative '../lib/mairies_xmas' require 'nokogiri'
require 'open-uri'

RSpec.describe "mairies_xmas" do
  describe "#scrape_mairies" do
    let(:base_url) { 'http://www.aude.fr' }
    let(:region_url) { 'http://www.aude.fr/annuaire-mairies-du-departement' }

    it "returns an array of hashes containing city names and emails" do
      allow(URI).to receive(:open).with(region_url).and_return(
        instance_double("StringIO", read: "<html><body><div class='directory-block__item'><div class='directory-block__title'>Mairie 1</div></div></body></html>")
      )

      allow(Nokogiri::HTML::Document).to receive(:parse).and_return(Nokogiri::HTML("<p class='infos__item -email'><a href='mailto:mairie1@example.com'>Email</a></p>"))

      expected_result = [{ "Mairie 1" => "mairie1@example.com" }]
      expect(scrape_mairies(base_url, region_url)).to eq(expected_result)
    end

    it "handles cases where email is not found" do
      allow(URI).to receive(:open).with(region_url).and_return(
        instance_double("StringIO", read: "<html><body><div class='directory-block__item'><div class='directory-block__title'>Mairie 2</div></div></body></html>")
      )

      allow(Nokogiri::HTML::Document).to receive(:parse).and_return(Nokogiri::HTML("<p class='infos__item'>Infos</p>"))

      expected_result = [{ "Mairie 2" => "Adresse e-mail non trouvée" }]
      expect(scrape_mairies(base_url, region_url)).to eq(expected_result)
    end
  end
end
