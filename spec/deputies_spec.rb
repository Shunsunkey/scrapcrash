require_relative '../lib/deputies.rb'

RSpec.describe 'Deputies' do
    it 'récupère les informations des députés correctement' do
      # Stubbing HTTP request and returning a sample HTML content
      stub_request(:get, 'https://www.voxpublic.org/spip.php?page=annuaire&cat=deputes&pagnum=50')
        .to_return(body: File.open('spec/fixtures/deputies_sample.html'), status: 200)
  
      # Call the method to scrape deputies information
      deputies = Deputies.scrape_deputies('https://www.voxpublic.org/spip.php?page=annuaire&cat=deputes&pagnum=50')
  
      # Check if the returned value is an array
      expect(deputies).to be_an(Array)
  
      # Check if each element in the array is a hash with the expected keys
      deputies.each do |deputy|
        expect(deputy).to be_a(Hash)
        expect(deputy).to have_key(:first_name)
        expect(deputy).to have_key(:last_name)
        expect(deputy).to have_key(:email)
      end
    end
  end