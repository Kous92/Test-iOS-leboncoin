//
//  APIError.swift
//  TestLeboncoiniOS
//
//  Created by Koussaïla Ben Mamar on 02/10/2021.
//

import Foundation

enum APIError: String, Error {
    case invalidURL = "Erreur: URL invalide."
    case networkError = "Pas de connexion Internet."
    case decodeError = "Erreur au décodage des données téléchargées."
    case apiError = "Erreur: Pas de réponse du serveur."
    case failed = "Une erreur est survenue."
}
