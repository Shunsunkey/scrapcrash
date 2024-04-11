require 'nokogiri'
require 'open-uri'

# Déclaration des variables de base
result = []

# URL de la page des députés
deputies_url = 'https://www.voxpublic.org/spip.php?page=annuaire&cat=deputes&pagnum=50'

# Récupération du contenu HTML de la page des députés
deputies_doc_html = Nokogiri::HTML(URI.open(deputies_url))

# Sélection de tous les blocs représentant chaque député
deputy_blocks = deputies_doc_html.css('.main-block.large-gutter ul.no_puce.list_ann li')

# Pour chaque bloc représentant un député
deputy_blocks.each do |deputy_block|
    # Récupération du nom du député
    deputy_name_element = deputy_block.at_css('h2.titre_normal')
    
    # Vérification si le bloc contenant le nom du député existe
    if deputy_name_element
      deputy_name = deputy_name_element.text.strip
      # Séparation du nom en prénom et nom de famille
      first_name, last_name = deputy_name.split(' ')
    
      # Recherche de l'adresse e-mail
      email_element = deputy_block.at_css('a.ann_mail')
  
      # Vérification si l'adresse e-mail existe
      if email_element
        email = email_element['href']
        # Ajout du nom complet et de l'adresse e-mail à la liste des résultats
        result << { first_name: first_name, last_name: last_name, email: email }
      else
        # Si aucune adresse e-mail n'est trouvée, on ajoute un message correspondant dans la liste des résultats
        result << { first_name: first_name, last_name: last_name, email: 'Adresse e-mail non trouvée' }
      end
    end
  end
  
  # Affichage des résultats
  result.each do |deputy|
    puts "{"
    puts "  \"first_name\" => \"#{deputy[:first_name]}\","
    puts "  \"last_name\" => \"#{deputy[:last_name]}\","
    puts "  \"email\" => \"#{deputy[:email]}\""
    puts "},"
  end
  