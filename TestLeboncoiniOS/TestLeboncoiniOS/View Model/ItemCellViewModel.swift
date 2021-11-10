//
//  ItemCellViewModel.swift
//  TestLeboncoiniOS
//
//  Created by Koussaïla Ben Mamar on 03/10/2021.
//

import Foundation

class ItemCellViewModel {
    // Pour la vue détaillée, le contenu de l'objet sera nécessaire. De même pour le tri par date.
    let itemProduct: Product?
    
    let image: String
    let itemTitle: String
    let itemCategory: String
    let itemPrice: Int
    let isUrgent: Bool
    let itemDescription: String
    var itemAddedDate: String
    let siret: String?
    
    // Pour le tri du plus récent au plus ancien (la date sera convertie en secondes)
    var dateTimeSeconds: Int = 0
    
    // Injection de dépendance
    init(itemProduct: Product? = nil, itemCategory: String = "") {
        self.itemProduct = itemProduct
        
        image = itemProduct?.imagesURL.small ?? ""
        itemTitle = itemProduct?.title ?? "Élément inconnu"
        self.itemCategory = itemCategory
        itemPrice = itemProduct?.price ?? 0
        isUrgent = itemProduct?.isUrgent ?? false
        itemDescription = itemProduct?.productDescription ?? "Pas de description."
        itemAddedDate = "Date inconnue"
        siret = itemProduct?.siret
        itemAddedDate = stringToDateFormat(date: itemProduct?.creationDate) ?? "Date inconnue"
    }
    
    // Conversion de la chaîne de date au format "yyyy-MM-dd'T'HH:mm:ss+0000Z" au format "dd/MM/yyyy à HH:mm"
    // Également, on va récupérer le temps en secondes de la date au format UNIX depuis 1970. Cela permettra de trier les annonces par date du plus récent au plus ancien.
    private func stringToDateFormat(date: String?) -> String? {
        if let publishDate = date {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

            if let date = formatter.date(from: publishDate) {
                formatter.locale = Locale(identifier: "fr_FR")
                formatter.dateStyle = .short
                
                let dateString = formatter.string(from: date) // Jour, mois, année
                
                formatter.dateStyle = .none
                formatter.timeStyle = .short
                
                // Le temps en secondes de la date au format UNIX depuis 1970
                dateTimeSeconds = Int(date.timeIntervalSince1970)
                
                let timeString = formatter.string(from: date) // Heure, minutes
                
                return "Le " + dateString + " à " + timeString
            }
        }

        return nil
    }
}
