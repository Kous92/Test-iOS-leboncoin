//
//  APIService.swift
//  TestLeboncoiniOS
//
//  Created by Koussaïla Ben Mamar on 04/10/2021.
//

import Foundation

protocol APIService {
    func fetchItems(completion: @escaping (Result<[Product], APIError>) -> ())
    func fetchItemCategories(completion: @escaping (Result<[Category], APIError>) -> ())
}
