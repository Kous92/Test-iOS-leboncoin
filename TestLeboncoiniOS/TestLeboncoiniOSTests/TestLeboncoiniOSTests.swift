//
//  TestLeboncoiniOSTests.swift
//  TestLeboncoiniOSTests
//
//  Created by Koussaïla Ben Mamar on 02/10/2021.
//

import XCTest
@testable import TestLeboncoiniOS

class TestLeboncoiniOSTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchItems() {
        let expectation = expectation(description: "Récupérer les annonces.")
        let apiService = LeboncoinMockAPIService()
        apiService.resourceName = "itemDataTest"
        
        apiService.fetchItems { result in
            expectation.fulfill()
            switch result {
            case .success(let products):
                XCTAssertGreaterThan(products.count, 0)
            case .failure(_):
                XCTFail()
            }
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testFetchCategories() {
        let expectation = expectation(description: "Récupérer les catégories.")
        let apiService = LeboncoinMockAPIService()
        apiService.resourceName = "categoryDataTest"
        
        apiService.fetchItemCategories { result in
            expectation.fulfill()
            switch result {
            case .success(let categories):
                XCTAssertGreaterThan(categories.count, 0)
            case .failure(_):
                XCTFail()
            }
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    // Pour tester les vues modèles, c'est plus compliqué, et là, lorsque j'ai essayé, XCTest se plaint avec ceci: API violation - multiple calls made to -[XCTestExpectation fulfill] for ... S'il n'y avait pas ce souci, la couverture du code en serait encore plus grande.
}
