//
//  LeboncoinAPIService.swift
//  TestLeboncoiniOS
//
//  Created by Koussaïla Ben Mamar on 02/10/2021.
//

import Foundation

// Les frameworks externes sont interdits dans ce test, le faisant de base avec Alamofire. On fera donc avec URLSession
class LeboncoinAPIService: APIService {
    private let itemsURL = URL(string: "https://raw.githubusercontent.com/leboncoin/paperclip/master/listing.json")
    private let itemCategoriesURL = URL(string: "https://raw.githubusercontent.com/leboncoin/paperclip/master/categories.json")
    
    func fetchItems(completion: @escaping (Result<[Product], APIError>) -> ()) {
        guard let url = itemsURL else {
            completion(.failure(.invalidURL))
            
            return
        }
        
        getRequest(url: url, completion: completion)
    }
    
    func fetchItemCategories(completion: @escaping (Result<[Category], APIError>) -> ()) {
        guard let url = itemCategoriesURL else {
            completion(.failure(.invalidURL))
            
            return
        }
        
        getRequest(url: url, completion: completion)
    }
    
    // Couche réseau générique
    fileprivate func getRequest<T: Decodable>(url: URL, completion: @escaping (Result<[T], APIError>) -> ()) {
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
                        var output: [T]?
                        
                        do {
                            output = try JSONDecoder().decode([T].self, from: data)
                        } catch {
                            completion(.failure(.decodeError))
                            return
                        }
                        
                        if let objects = output {
                            completion(.success(objects))
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
