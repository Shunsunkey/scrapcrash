require 'nokogiri'
require 'open-uri'

# Méthode pour récupérer le nombre total de pages
def total_pages(url)
    doc = Nokogiri::HTML(URI.open(url))
    last_page_link = doc.at_css('.pagination-button:last-child a')
    if last_page_link
      last_page_href = last_page_link['href']
      if last_page_href
        page_number = last_page_href.scan(/page=(\d+)/).flatten.first
        if page_number
          return page_number.to_i
        end
      end
    end
    # Si quelque chose ne va pas, retourner 1 par défaut
    return 1
  end
  

# Méthode pour récupérer les données depuis CoinMarketCap
def scrape_coinmarketcap
  base_url = "https://coinmarketcap.com/all/views/all/"
  total_pages = total_pages(base_url)
  crypto_data = []

  (1..total_pages).each do |page_number|
    # Construire l'URL de la page
    page_url = "#{base_url}?page=#{page_number}"
    doc = Nokogiri::HTML(URI.open(page_url))

    # Utiliser CSS pour sélectionner les lignes de la table des cryptomonnaies
    doc.css('.cmc-table-row').each do |row|
      crypto_name_element = row.at_css('.cmc-table__cell--sort-by__name .cmc-link')
      crypto_price_element = row.at_css('.cmc-table__cell--sort-by__price span')

      # Vérifier que les éléments sont présents
      if crypto_name_element && crypto_price_element
        crypto_name = crypto_name_element.text.strip
        crypto_price = crypto_price_element.text.strip.gsub(/[^\d.]/, '').to_f

        # Vérifier que le nom et le prix ne sont pas vides
        if !crypto_name.empty? && crypto_price > 0
          crypto_data << { crypto_name => crypto_price }
          puts "Nom : #{crypto_name}, Prix : #{crypto_price}"
        end
      end
    end
  end

  return crypto_data
end

# Appel de la méthode pour récupérer les données
crypto_data = scrape_coinmarketcap

# Affichage du résultat
puts crypto_data.inspect
