# Test iOS leboncoin

Exercice officiel de leboncoin, en tant que test technique iOS, réalisé par Koussaïla BEN MAMAR.

## Table des matières
- [Objectifs](#objectifs)
- [Test](#test)
- [Ma solution](#solution)

## <a name="objectifs"></a>Objectifs

Créer une application universelle en Swift. Celle-ci devra afficher une liste d'annonces disponibles sur l'API `https://raw.githubusercontent.com/leboncoin/paperclip/master/listing.json`

La correspondance des ids de catégories se trouve sur l'API `https://raw.githubusercontent.com/leboncoin/paperclip/master/categories.json`

Le contrat d'API est visualisable à cette adresse :
`https://raw.githubusercontent.com/leboncoin/paperclip/master/swagger.yaml`<br>

**Les points attendus dans le projet sont:**
- Une architecture qui respecte le principe de responsabilité unique
- Création des interfaces avec autolayout directement dans le code (pas de storyboard ni
de xib, ni de SwiftUI)
- Développement en Swift
- Le code doit être versionné (Git) sur une plateforme en ligne type Github ou Bitbucket
(pas de zip) et doit être immédiatement exécutable sur la branche master
- Aucune librairie externe n'est autorisée
- Le projet doit être compatible pour iOS 12+ (compilation et tests)

**Nous porterons également une attention particulière sur les points suivants:**
- Les tests unitaires
- Les efforts UX et UI
- Performances de l'application
- Code swifty

### Liste d'items
Chaque item devra comporter au minimum une image, une catégorie, un titre et un prix.

Un indicateur devra aussi avertir si l'item est urgent.

### Filtre

Un filtre devra être disponible pour afficher seulement les items d'une catégorie.

### Tri
Les items devront être triés par date.

Attention cependant, les annonces marquées comme urgentes devront remonter en haut de la liste.

### Page de détail
Au tap sur un item, une vue détaillée devra être affichée avec toutes les informations fournies dans l'API.
<br><br>
Vous disposez d'un délai d'une semaine pour réaliser le projet.<br>
Bonne chance. L’équipe iOS a hâte de voir votre projet !

## <a name="solution"></a>Ma solution

Au niveau architecture modulaire, s'il faut respecter le principe de responsabilité unique (Single Responsibility), il est clair que **l'architecture la plus simple (et celle par défaut de UIKit) étant MVC est à bannir. L'architecture MVP est également à bannir dans ce cas de figure.**. 

Moi même n'étant pas encore à l'aise avec les architectures les plus modulaires et les plus complexes (VIPER, Clean architecture,...), j'ai donc choisi l'architecture **MVVM** afin de respecter au mieux le principe de responsabilité unique et de permettre une meilleure couverture des tests (aussi du fait que c'est une architecture modulaire pas trop complexe pour les débutants).

La solution utilise **UIKit**. L'ensemble des éléments visuels sont 100% full code, étant donné qu'il est **strictement interdit** dans ce test d'utiliser **SwiftUI**, les **XIB** ou les **Storyboard**.

Au niveau versionning, depuis le scandale raciste aux États-Unis lié au policier qui a provoqué la mort de George FLOYD (paix à son âme), GitHub a décidé par la suite de remplacer le nom de la branche principale **master** par **main**.

Aucun framework externe n'est utilisé étant donné qu'ils sont **strictement interdits** dans ce test.

Concernant les tests, j'ai mis en place 9 tests unitaires des vues modèles et des appels réseau par le biais du mocking, ces tests couvrent **44,5% du code**. De même pour les tests UI, avec une couverture de **82,5% du code**. En tout, la couverture du code en exécutant les tests unitaires (white box) et les tests UI (black box) s'élève à **87,2%**.

### Difficultés rencontrées

- Le fait que toute assistance (storyboard, XIB, SwiftUI) pour mettre en place les éléments visuels soit interdite. Cela prend donc plus de temps pour les configurer, les positionner avec Auto Layout par code.
- L'UI/UX optimisé avec les iPad, l'aspect ratio (images de formats différents), cela me prendrait trop de temps.
- La mise en place de l'architecture **MVVM**, notamment pour assurer la testabilité et surtout pour respecter au mieux le principe de responsabilité unique.
- La configuration du projet Xcode afin qu'il soit compatible au minimum avec iOS 12.
- La couverture du code par les tests (unitaires et UI), il est difficile de tester les vues modèles avec plusieurs appels réseau à la suite (il faut plusieurs `expectations` pour que cela fonctionne)
- Je ne dispose pas de compte Apple Developer payant (enregistré à l'Apple Developer Program).