require 'nokogiri'
require 'open-uri'

# Déclaration des variables de base
result = []
base_url = 'http://www.aude.fr'
region_url = 'http://www.aude.fr/annuaire-mairies-du-departement'

# Récupération du contenu HTML de la page des mairies du département de l'Aude
district_doc_html = Nokogiri::HTML(URI.open(region_url))
# Sélection de tous les blocs représentant chaque mairie
city_links = district_doc_html.css('.directory-block__item')

# Pour chaque bloc représentant une mairie
city_links.each do |city_link|
  # Récupération du nom de la mairie
  city_name = city_link.at_css('.directory-block__title').text.strip
  # Récupération de l'URL relative de la mairie
  city_relative_url = city_link.at_css('a')['href']
  # Construction de l'URL complète de la mairie
  city_url = "#{base_url}#{city_relative_url}"

  # Récupération du contenu HTML de la page de la mairie
  city_doc_html = Nokogiri::HTML(URI.open(city_url))
  # Sélection de l'élément contenant l'adresse e-mail de la mairie
  email_element = city_doc_html.at_css('p.infos__item.-email a')

  # Vérification si l'élément contenant l'adresse e-mail existe
  if email_element
    # Récupération de l'adresse e-mail
    email = email_element['href'].sub('mailto:', '')
    # Ajout du nom de la mairie et de son adresse e-mail à la liste des résultats
    result << { city_name => email }
  else
    # Si aucune adresse e-mail n'est trouvée, on ajoute un message correspondant dans la liste des résultats
    result << { city_name => 'Adresse e-mail non trouvée' }
  end
end

# Affichage des résultats
puts result
