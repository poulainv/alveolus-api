#!/bin/env ruby
# encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#!/bin/env ruby
# encoding: utf-8


Webapp.delete_all
Tag.delete_all
TagAppRelation.delete_all

Webapp.create( :title =>'Babyloan',
  :caption => 'Le site des microcrédits solidaires',
  :description => 'Babyloan est le premier site Européen de microcrédits solidaires
C\'est une nouvelle forme de solidarité par le Prêt, qui permet à des micro-entrepreneurs de sortir de la précarité grâce au fruit de leur travail.',
  :url => 'http://www.babyloan.org/',
  :validate => true,
  :nb_click_preview => 23,
  :nb_click_detail => 43,
  :nb_click_url => 13 ).add_tags(["microcredit","solidarite","pret"])
           


Webapp.create( :title =>'CupOfTeach',
  :caption => 'Cup of teach est la première université entre particuliers. Découvrez des ateliers uniques près de chez vous.',
  :description => 'Cup of teach, cʼest avant tout lʼhistoire de deux amis qui avaient un grand projet : permettre à chacun d’entre nous d’apprendre toute sa vie durant. En partageant nos connaissances, en découvrant celles des autres, nous créons une véritable encyclopédie vivante et un nouveau chemin vers la découverte. Toutes les passions y tiennent la première place, surtout les vôtres !',
  :url => 'https://www.cupofteach.com/',
  :validate => true,
  :nb_click_preview => 29,
  :nb_click_detail => 03,
  :nb_click_url => 1).add_tags(["formation","universite","atelier","partage"])
              


Webapp.create( :title =>'Deways',
  :caption => 'Louez le véhicule d\'un membre de la communauté Deways proche de chez vous. C\'est pratique, économique, convivial et sûr !',
  :description => 'Deways est la première communauté de location de voitures entre particuliers. Notre communauté est composée de conducteurs et de propriétaires : que vous soyez l’un ou l’autre, tout s’y fait dans un climat accueillant, convivial et sécurisé grâce notamment à l’assurance MACIF-DEWAYS.',
  :url => 'http://www.deways.com/',
  :validate => true,
  :nb_click_preview => 80,
  :nb_click_detail => 43,
  :nb_click_url => 13).add_tags(["voiture","partage","location","louer"])


Webapp.create( :title =>'LaMachineDuVoisin',
  :caption => 'La Machine Du Voisin met gratuitement en relation les personnes cherchant à faire leur lessive et celles souhaitant partager leur machine à laver.',
  :description => 'Ce projet original a pour vocation de mettre en relation d’heureux propriétaires de machines à laver avec des personnes comme vous et nous, dépourvues du précieux appareil ou trop éloignées d’une laverie, qui souhaitent, en échange d’un beau sourire et/ou d’une rémunération modique, partager un peu de leur temps et le tambour de leurs lave-linge.',
  :url => 'http://www.lamachineduvoisin.fr/',
  :validate => true,
  :nb_click_preview => 67,
  :nb_click_detail => 46,
  :nb_click_url => 19).add_tags(["pret","location","electo-menager","partage"])
             



Webapp.create( :title =>'Covoiturage',
  :caption => 'Covoiturage : Voyagez moins cher en toute confiance - 2 Millions de conducteurs et passagers. Départs immédiats !',
  :description => 'Notre ambition : rendre le covoiturage toujours plus facile, fiable et efficace en mettant simplement en relation des conducteurs effectuant un trajet, ponctuel ou régulier, et des passagers souhaitant effectuer ce même trajet.

Le but : faire ainsi coïncider les besoins, partager les frais entre covoitureurs, optimiser l’utilisation des véhicules et réduire notre impact sur notre planète par une réduction de nos émissions de CO2. Tout le monde a à y gagner !',
  :url => 'http://www.covoiturage.fr/',
  :validate => true,
  :nb_click_preview => 93,
  :nb_click_detail => 23,
  :nb_click_url => 53).add_tags(["voiture","trajet","covoiturage","developpement durable"])
             



Webapp.create( :title =>'MyMajorCompany',
  :caption => 'Pionnier du financement participatif mondial, MMC vous propose de financer et de donner vie à tout type de projets culturels et innovants !',
  :description => 'My Major Company est un des pionniers du financement participatif mondial, et aujourd’hui leader du secteur en Europe, par la taille de sa communauté, les montants levés – plus de 12 millions d\'euros sur près de 42.000 projets en France, en Allemagne et en Angleterre – et les succès commerciaux engendrés.',
  :url => 'http://www.mymajorcompany.com/',
  :validate => true,
  :nb_click_preview => 13,
  :nb_click_detail => 13,
  :nb_click_url => 3).add_tags(["musique","financement","participatif","culture"])


Webapp.create( :title =>'Artilinki',
  :caption => 'Artilinki est le premier réseau social international dédié à l’art et à la créativité.
En 13 langues et ouvert à l\'ensemble des filières, il contribue au décloisonnement des arts.',
  :description => 'Artilinki n\'est pas un réseau parmi tant d\'autres mais un réseau dédié à l\'art sous toutes ses formes.
Avec son site Web, son application Mobile et ses Meet\'ups, Artilinki est perçu comme un vrai moteur de mise en relation.
Un réseau utile, alternatif et indépendant dont le but est d\'accompagner la mutation du marché de l\'art, aider à la mise en réseau avec une attention particulière envers ceux qui sont issus des zones défavorisées et contribuer au décloisonnement des arts.',
  :url => 'http://www.artilinki.com/fr/home',
  :validate => true,
  :nb_click_preview => 23,
  :nb_click_detail => 0,
  :nb_click_url => 0).add_tags(["culture","reseaux","art"])


Webapp.create( :title =>'TED',
  :caption => 'Conférences de personnalités parmi les plus fascinantes au monde : des penseurs radicaux de l\'éducation, des génies de la technologie, des non-conformistes de la médecine...',
  :description => 'Conferences captivantes par des gens remarquables, gratuites a travers le monde.
TED présente des conférences de personnalités parmi les plus fascinantes au monde : des penseurs radicaux de l\'éducation, des génies de la technologie, des non-conformistes de la médecine, des gourous du monde des affaires, et des légendes de la musique.
Partez à la découverte de plus de 1300 TEDTalks, à regarder ou à écouter (avec du nouveau contenu ajouté chaque semaine).',
  :url => 'http://www.ted.com',
  :validate => true,
  :nb_click_preview => 73,
  :nb_click_detail => 13,
  :nb_click_url => 5).add_tags(["videos","partage","connaissance","conference","formation"])


Webapp.create( :title =>'Fleex',
  :caption => 'Apprenez l\'anglais avec vos vidéos préférées',
  :description => 'Les vidéos que vous aimez
Grâce à fleex, apprenez l’anglais avec les vidéos que vous aimez. A partir des séries TV et films stockés sur votre disque dur, fleex construit à la volée une vraie expérience éducative pour vous permettre d\'améliorer votre pratique de la langue. A court d\'idées ? Choisissez dans notre catalogue l’une des 700+ vidéos que nous avons sélectionnées pour vous !',
  :url => 'http://beta.fleex.tv/',
  :validate => true,
  :nb_click_preview => 63,
  :nb_click_detail => 42,
  :nb_click_url => 1).add_tags(["formation","anglais","videos"])

Webapp.create( :title =>'La Ruche qui dit Oui !',
  :caption => 'La Ruche qui dit Oui ! permet de vous réunir pour acheter directement aux producteurs de votre région.',
  :description => 'Comment ça marche ?
C\'est en combinant circuits courts et achats groupés que La Ruche qui Dit Oui ! permet aux producteurs et aux consommateurs de bénéficier de meilleurs prix.
Que fait l\'équipe de la Ruche qui dit Oui ! ?
– Offre un site efficace pour organiser le commerce avec les producteurs.
– Vérifie les certifications relative à l\'hygiène et les labels des fournisseurs.
– Sécurise les paiements et gère la comptabilité des Ruches.',
  :url => 'http://www.laruchequiditoui.fr/',
  :validate => true,
  :nb_click_preview => 23,
  :nb_click_detail => 43,
  :nb_click_url => 13
).add_tags(["alimentation","developpement durable","agriculture","local"])

User.create( :email => "roger.federer@gmail.com",
 :password => "nadal90")
User.create( :email => "nico.sarko@gmail.com",
  :password => "nadal09")
User.create( :email => "joel.miceh@gmail.com",
  :password => "nadal89")
User.create( :email => "nadia.croche@hotmail.com",
  :password => "orgasme")
User.create( :email => "francis.jimoula@gmail.com",
  :password => "nadal")


Comment.create(:webapp_id => 1, :user_id=>1,:body => "J'adore ce site")
Comment.create(:webapp_id => 1, :user_id=>2,:body => "Excellente idée")
Comment.create(:webapp_id => 1, :user_id=>3,:body => "Conférences géniales")
Comment.create(:webapp_id => 2, :user_id=>1,:body => "En anglais, je comprends rien")
Comment.create(:webapp_id => 2, :user_id=>2,:body => "Very interesting")
Comment.create(:webapp_id => 3, :user_id=>3,:body => "Bien bien")
Comment.create(:webapp_id => 3, :user_id=>4,:body => "J'aime commenter")
Comment.create(:webapp_id => 4, :user_id=>5,:body => "J'adore ce site")
Comment.create(:webapp_id => 5, :user_id=>1,:body => "Une idée intéressante")
Comment.create(:webapp_id => 6, :user_id=>2,:body => "Concept fun")
Comment.create(:webapp_id => 7, :user_id=>3,:body => "Je kifffffffff")
Comment.create(:webapp_id => 8, :user_id=>1,:body => "J'adore ce site")
Comment.create(:webapp_id => 8, :user_id=>2,:body => "Excellente idée")
Comment.create(:webapp_id => 8, :user_id=>3,:body => "Conférences géniales")
Comment.create(:webapp_id => 9, :user_id=>1,:body => "En anglais, je comprends rien")
Comment.create(:webapp_id => 9, :user_id=>2,:body => "Very interesting")
Comment.create(:webapp_id => 9, :user_id=>3,:body => "Bien bien")
Comment.create(:webapp_id => 10, :user_id=>4,:body => "J'aime commenter")
Comment.create(:webapp_id => 10, :user_id=>5,:body => "J'adore ce site")
Comment.create(:webapp_id => 6, :user_id=>1,:body => "Une idée intéressante")
