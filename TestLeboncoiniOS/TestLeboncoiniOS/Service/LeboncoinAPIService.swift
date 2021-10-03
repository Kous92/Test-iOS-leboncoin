//
//  LeboncoinAPIService.swift
//  TestLeboncoiniOS
//
//  Created by Koussaïla Ben Mamar on 02/10/2021.
//

import Foundation

// Les frameworks externes sont interdits dans ce test, le faisant de base avec Alamofire. On fera donc avec URLSession
class LeboncoinAPIService {
    private let itemsURL = URL(string: "https://raw.githubusercontent.com/leboncoin/paperclip/master/listing.json")
    private let itemCategoriesURL = URL(string: "https://raw.githubusercontent.com/leboncoin/paperclip/master/categories.json")
    
    func fetchItems(completion: @escaping (Result<[Product], APIError>) -> ()) {
        guard let url = itemsURL else {
            completion(.failure(.invalidURL))
            
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            // Erreur réseau
            guard error == nil else {
                print(error?.localizedDescription ?? "Erreur réseau")
                completion(.failure(.networkError))
                
                return
            }
            
            // Pas de réponse du serveur
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.apiError))
                
                return
            }
            
            switch httpResponse.statusCode {
                // Code 200, vérifions si les données existent
                case (200...299):
                    if let productData = data {
                        var output: [Product]?
                        
                        do {
                            output = try JSONDecoder().decode([Product].self, from: productData)
                        } catch {
                            print(error)
                            completion(.failure(.decodeError))
                            return
                        }
                        
                        if let products = output {
                            // print("Articles disponibles: \(newsData.count)")
                            completion(.success(products))
                        }
                    } else {
                        completion(.failure(.failed))
                    }
                default:
                    completion(.failure(.failed))
            }
        }
        task.resume()
    }
    
    func fetchItemCategories(completion: @escaping (Result<[Category], APIError>) -> ()) {
        guard let url = itemCategoriesURL else {
            completion(.failure(.invalidURL))
            
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            // Erreur réseau
            guard error == nil else {
                print(error?.localizedDescription ?? "Erreur réseau")
                completion(.failure(.networkError))
                
                return
            }
            
            // Pas de réponse du serveur
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.apiError))
                
                return
            }
            
            switch httpResponse.statusCode {
                // Code 200, vérifions si les données existent
                case (200...299):
                    if let data = data {
                        var output: [Category]?
                        
                        do {
                            output = try JSONDecoder().decode([Category].self, from: data)
                        } catch {
                            completion(.failure(.decodeError))
                            return
                        }
                        
                        if let categories = output {
                            // print("Articles disponibles: \(newsData.count)")
                            completion(.success(categories))
                        }
                    } else {
                        completion(.failure(.failed))
                    }
                default:
                    completion(.failure(.failed))
            }
        }
        task.resume()
    }
}
