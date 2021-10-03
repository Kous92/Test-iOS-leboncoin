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
            let formatter1 = DateFormatter()
            let formatter2 = DateFormatter()
            formatter1.locale = Locale(identifier: "en_US_POSIX")
            formatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            formatter2.locale = Locale(identifier: "en_US_POSIX")
            formatter2.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

            if let date = formatter1.date(from: publishDate), let time = formatter2.date(from: publishDate) {
                formatter1.locale = Locale(identifier: "fr_FR")
                formatter2.locale = Locale(identifier: "fr_FR")
                formatter1.dateStyle = .short
                formatter2.timeStyle = .short
                
                // Le temps en secondes de la date au format UNIX depuis 1970
                dateTimeSeconds = Int(date.timeIntervalSince1970)
                
                formatter1.string(from: date) // Jour, mois, année
                formatter2.string(from: time) // Heures et minutes
                
                return "Le " + formatter1.string(from: date) + " à " + formatter2.string(from: time)
            }
        }

        return nil
    }
}
