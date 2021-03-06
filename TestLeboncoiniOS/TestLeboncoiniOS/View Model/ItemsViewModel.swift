//
//  ItemsViewModel.swift
//  TestLeboncoiniOS
//
//  Created by Koussaïla Ben Mamar on 03/10/2021.
//

import Foundation

class ItemsViewModel {
    // Le type du protocole servira pour les tests ou la partie application (cela étant géré par l'injection de dépendance)
    private let apiService: APIService?
    
    // L'élément-clé de l'architecture MVVM pour le data binding entre la vue et la vue modèle. La vue ayant une référence sur ce callback va permettre la mise à jour de son contenu.
    var callback: (_ type: CallbackType) -> () = { _ in }
    
    // C'est cette vue modèle qui a un contact avec le modèle. La vue ne doit pas connaître le modèle.
    var items = [Product]()
    var categories = [Category]()
    
    // Chaque cellule a sa vue modèle, la vue ne doit rien savoir du modèle.
    var itemCellViewModels = [ItemCellViewModel]()
    
    // Avec ou sans filtrage. On conserve aussi un tableau original avant filtrage.
    var itemCellsViewModels = [ItemCellViewModel]()
    
    var isFiltered = false
    
    // Injection de dépendance de l'objet qui gère l'appel de l'API
    init(apiService: APIService = LeboncoinAPIService()) {
        self.apiService = apiService
    }
    
    func getItems() {
        let group = DispatchGroup()
        var failureMessage = ""
        var failed = false
        
        // L'objectif ici est de pouvoir attendre les résultats des 2 appels HTTP avant d'intéragir avec la vue
        group.enter()
        apiService?.fetchItemCategories { [weak self] result in
            defer {
                group.leave()
            }
            
            switch result {
            case .success(let categories):
                guard categories.count > 0 else {
                    failed = true
                    failureMessage = "Pas de catégories disponibles."
                    return
                }
                
                // On va ajouter en plus des catégories téléchargées, une catégorie générique qui n'aura aucun filtre
                self?.categories.append(Category(id: 0, name: "Toutes catégories"))
                self?.categories += categories
            case .failure(let error):
                print(error.rawValue)
                failed = true
                failureMessage = "Pas de catégories disponibles."
            }
        }
        
        group.enter()
        apiService?.fetchItems { [weak self] result in
            defer {
                group.leave()
            }
            
            switch result {
            case .success(let products):
                guard products.count > 0 else {
                    failed = true
                    failureMessage = "Pas d'annonces disponibles."
                    return
                }
                self?.items = products
                self?.itemCellViewModels = self?.items.compactMap { product in
                    let categoryId = self?.categories.firstIndex { category in
                        return product.categoryID == category.id
                    }
                    
                    var category = "Inconnu"
                    
                    if let categoryId = categoryId {
                        category = self?.categories[categoryId].name ?? "Inconnu"
                    }
                    
                    return ItemCellViewModel(itemProduct: product, itemCategory: category)
                } ?? []
                
                // Tri des éléments par urgence et par date (du plus récent au plus ancien)
                // Version optimisée et plus performante
                let sortedItems = self?.itemCellViewModels.sorted(by: { item1, item2 in
                    if item1.isUrgent && !item2.isUrgent {
                        return true
                    } else if !item1.isUrgent && item2.isUrgent {
                        return false
                    }
                    
                    return item1.dateTimeSeconds > item2.dateTimeSeconds
                }) ?? []
                
                self?.itemCellViewModels = sortedItems // La liste originale triée non filtrée
                self?.itemCellsViewModels = self?.itemCellViewModels ?? [] // La liste filtrée (on l'initialise en copie de la liste originale)
            case .failure(let error):
                print(error.rawValue)
                failed = true
                failureMessage = error.rawValue
            }
        }
        
        // Une fois les 2 appels effectués, on met à jour l'interface utilisateur (group.notify se déclenche seulement si les 2 appels du groupe sont entrés et sortis.
        group.notify(queue: .main) { [weak self] in
            // S'il y a eu une erreur, le callback va notifier la vue qu'il y a une erreur à afficher, par le biais du data binding de l'architecture MVVM.
            if failed {
                self?.callback(.failure(failureMessage))
            } else {
                // Dès que les données sont mises à jour dans la vue modèle, le callback va permettre le data binding avec la vue pour que celle-ci mette automatiquement à jour les éléments visuels. C'est la partie-clé de l'architecture MVVM.
                self?.callback(.reload)
            }
        }
    }
    
    func searchItems(query: String) {
        itemCellsViewModels = itemCellViewModels.filter { viewModel in
            let title = viewModel.itemTitle.lowercased()
            return title.contains(query.lowercased())
        }
        
        if itemCellsViewModels.count > 0 {
            isFiltered = true
            callback(.reload)
        } else {
            callback(.failure("Aucune annonce disponible pour l'élément recherché: \(query)"))
        }
    }
    
    func filterItems(category: String) {
        itemCellsViewModels = itemCellViewModels.filter { viewModel in
            return viewModel.itemCategory == category
        }
        
        if itemCellsViewModels.count > 0 {
            isFiltered = true
            callback(.reload)
        } else {
            callback(.failure("Aucune annonce disponible pour la catégorie: \(category)"))
        }
    }
    
    func resetList() {
        itemCellsViewModels = itemCellViewModels
        isFiltered = false
        callback(.reload)
    }
}
