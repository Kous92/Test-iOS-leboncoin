//
//  LeboncoinMockAPIService.swift
//  TestLeboncoiniOS
//
//  Created by Koussaïla Ben Mamar on 04/10/2021.
//

import Foundation

class LeboncoinMockAPIService: APIService {
    var resourceName = ""
    
    func fetchItems(completion: @escaping (Result<[Product], APIError>) -> ()) {
        print("Resource: \(resourceName)")
        resourceName = "itemDataTest"
        
        // Simulation d'une tâche asynchrone
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            // Pour le test, on se focalisera que sur un élément (que j'ai récupéré du JSON en ligne) à titre d'exemple
            guard let path = Bundle.main.path(forResource: self?.resourceName, ofType: "json") else {
                print("Fichier itemDataTest.json introuvable")
                completion(.failure(.failed))
                return
            }
            
            let url = URL(fileURLWithPath: path)
            var products: [Product]?
            
            do {
                // Récupération des données JSON en type Data
                let data = try Data(contentsOf: url)
                
                // Décodage des données JSON en objets exploitables
                products = try JSONDecoder().decode([Product].self, from: data)
                
                if let result = products {
                    completion(.success(result))
                    return
                } else {
                    completion(.failure(.decodeError))
                    return
                }
            } catch {
                print("ERREUR: \(error)")
                completion(.failure(.decodeError))
            }
        }
    }
    
    func fetchItemCategories(completion: @escaping (Result<[Category], APIError>) -> ()) {
        print("Resource: \(resourceName)")
        resourceName = "categoryDataTest"
        
        // Simulation d'une tâche asynchrone
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            // Pour le test, on se focalisera que sur un élément (que j'ai récupéré du JSON en ligne) à titre d'exemple
            guard let path = Bundle.main.path(forResource: self?.resourceName, ofType: "json") else {
                print("Fichier categoryDataTest.json introuvable")
                completion(.failure(.failed))
                return
            }
            
            let url = URL(fileURLWithPath: path)
            var categories: [Category]?
            
            do {
                // Récupération des données JSON en type Data
                let data = try Data(contentsOf: url)
                
                // Décodage des données JSON en objets exploitables
                categories = try JSONDecoder().decode([Category].self, from: data)
                
                if let result = categories {
                    completion(.success(result))
                    return
                } else {
                    completion(.failure(.decodeError))
                    return
                }
            } catch {
                print("ERREUR: \(error)")
                completion(.failure(.decodeError))
            }
        }
    }
    
    
}
