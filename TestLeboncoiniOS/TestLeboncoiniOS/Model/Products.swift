//
//  Products.swift
//  TestiOSLeboncoin
//
//  Created by Koussaïla Ben Mamar on 28/09/2021.
//

import Foundation

struct Product: Codable {
    var id, categoryID: Int
    var title, productDescription: String
    var price: Int
    var imagesURL: ImagesURL
    var creationDate: String
    var isUrgent: Bool
    var siret: String?

    enum CodingKeys: String, CodingKey {
        case id
        case categoryID = "category_id"
        case title
        case productDescription = "description"
        case price
        case imagesURL = "images_url"
        case creationDate = "creation_date"
        case isUrgent = "is_urgent"
        case siret
    }
}

// MARK: - ImagesURL
struct ImagesURL: Codable {
    var small, thumb: String?
}
