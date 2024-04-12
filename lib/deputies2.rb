require 'nokogiri'
require 'open-uri'

url = 'https://www.voxpublic.org/spip.php?page=annuaire&cat=deputes&pagnum=50'

# Méthode pour extraire les noms des députés et leurs adresses e-mail
def scrape_deputies(url)
  doc = Nokogiri::HTML(URI.open(url))
  deputies = []

  # Sélection des balises <h2> contenant les noms des députés
  deputy_names = doc.css('h2.titre_normal')

  # Pour chaque balise <h2>, récupérer le nom du député et ses adresses e-mail
  deputy_names.each do |deputy_name|
    full_name = deputy_name.text.strip
    # Diviser le nom complet en prénom et nom de famille
    first_name, last_name = full_name.split(' ', 2)

    # Sélectionner les balises <a> contenant les adresses e-mail
    email_links = doc.css('li span:contains("Email") + a.ann_mail')      
    # Extraire les adresses e-mail des balises <a>
    emails = email_links.map { |link| link['href'].sub('mailto:', '') }  

    # Ajouter le nom du député et ses adresses e-mail à la liste des députés
    deputies << { "first_name" => first_name, "last_name" => last_name, "email" => emails.join(', ') }
  end

  deputies
end

# Appel de la méthode pour scraper les députés
deputies = scrape_deputies(url)

# Affichage des députés sous forme de liste
puts "a = ["
deputies.each do |deputy|
  puts "  {"
  puts "    \"first_name\" => \"#{deputy['first_name']}\","
  puts "    \"last_name\" => \"#{deputy['last_name']}\","
  puts "    \"email\" => \"#{deputy['email'].gsub(', ', "\",\n    \"")}\""
  puts "  },"
end
puts "]"
