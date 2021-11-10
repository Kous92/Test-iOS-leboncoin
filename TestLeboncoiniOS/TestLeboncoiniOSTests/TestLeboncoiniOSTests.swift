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
    
    // Pour tester les vues modèles, dans le cas ici où il faut effectuer 2 appels HTTP de suite, il faut utiliser plusieurs "expectations".
    func testViewModelFetchData() {
        let viewModel = ItemsViewModel(apiService: LeboncoinMockAPIService())
        let expectation1 = XCTestExpectation(description: "Vérifier que la vue modèle récupère des données")
        let expectation2 = XCTestExpectation(description: "Téléchargement")
        
        // Data binding
        viewModel.callback = { type in
            switch type {
            case .reload:
                expectation1.fulfill()
                XCTAssertGreaterThan(viewModel.categories.count, 0)
                XCTAssertGreaterThan(viewModel.items.count, 0)
                print(viewModel.items)
                XCTAssertGreaterThan(viewModel.itemCellsViewModels.count, 0)
            case .failure(_):
                XCTFail()
            }
        }
        
        viewModel.getItems()
        expectation2.fulfill()
        wait(for: [expectation1, expectation2], timeout: 10)
    }
    
    func testViewModelFilterItems() {
        let viewModel = ItemsViewModel(apiService: LeboncoinMockAPIService())
        let expectation1 = XCTestExpectation(description: "Vérifier que la vue modèle récupère des données")
        let expectation2 = XCTestExpectation(description: "Filtrage effectué")
        
        // Data binding
        viewModel.callback = { type in
            switch type {
            case .reload:
                if viewModel.isFiltered {
                    print(viewModel.items.count)
                    XCTAssertGreaterThan(viewModel.itemCellsViewModels.count, 0)
                    expectation2.fulfill()
                }
            case .failure(_):
                XCTFail()
            }
        }
        
        viewModel.getItems()
        expectation1.fulfill()
        
        viewModel.filterItems(category: "Véhicule")
        XCTAssertEqual(viewModel.itemCellsViewModels[0].itemTitle, "Nissan Skyline GT-R R34 V-Spec II")
        wait(for: [expectation1, expectation2], timeout: 10)
    }
    
    func testViewModelFilterFailed() {
        let viewModel = ItemsViewModel(apiService: LeboncoinMockAPIService())
        let expectation1 = XCTestExpectation(description: "Vérifier que la vue modèle récupère des données")
        let expectation2 = XCTestExpectation(description: "Filtrage effectué")
        
        // Data binding
        viewModel.callback = { type in
            switch type {
            case .reload:
                XCTFail()
            case .failure(_):
                expectation2.fulfill()
            }
        }
        
        viewModel.getItems()
        expectation1.fulfill()
        
        viewModel.filterItems(category: "Luxe")
        wait(for: [expectation1, expectation2], timeout: 10)
    }
    
    func testViewModelResetItems() {
        let viewModel = ItemsViewModel(apiService: LeboncoinMockAPIService())
        let expectation1 = XCTestExpectation(description: "Vérifier que la vue modèle récupère des données")
        let expectation2 = XCTestExpectation(description: "Filtrage effectué")
        let expectation3 = XCTestExpectation(description: "Réinitialisation effectuée")
        
        // Data binding
        viewModel.callback = { type in
            switch type {
            case .reload:
                if viewModel.isFiltered {
                    expectation2.fulfill()
                } else {
                    expectation3.fulfill()
                }
            case .failure(_):
                XCTFail()
            }
        }
        
        viewModel.getItems()
        expectation1.fulfill()
        
        viewModel.filterItems(category: "Véhicule")
        XCTAssertEqual(viewModel.itemCellsViewModels[0].itemTitle, "Nissan Skyline GT-R R34 V-Spec II")
        viewModel.resetList()
        XCTAssertGreaterThan(viewModel.itemCellsViewModels.count, 1)
        wait(for: [expectation1, expectation2, expectation3], timeout: 10)
    }
    
    func testViewModelSearchItems() {
        let viewModel = ItemsViewModel(apiService: LeboncoinMockAPIService())
        let expectation1 = XCTestExpectation(description: "Vérifier que la vue modèle récupère des données")
        let expectation2 = XCTestExpectation(description: "Recherche et filtrage effectué")
        
        // Data binding
        viewModel.callback = { type in
            switch type {
            case .reload:
                if viewModel.isFiltered {
                    XCTAssertGreaterThan(viewModel.itemCellsViewModels.count, 0)
                    expectation2.fulfill()
                }
            case .failure(_):
                XCTFail()
            }
        }
        
        viewModel.getItems()
        expectation1.fulfill()
        
        viewModel.searchItems(query: "iPhone 13 Pro")
        XCTAssertEqual(viewModel.itemCellsViewModels[0].itemTitle, "iPhone 13 Pro Max 1 TB (neuf)")
        wait(for: [expectation1, expectation2], timeout: 10)
    }
    
    func testViewModelSearchFailure() {
        let viewModel = ItemsViewModel(apiService: LeboncoinMockAPIService())
        let expectation1 = XCTestExpectation(description: "Vérifier que la vue modèle récupère des données")
        let expectation2 = XCTestExpectation(description: "Recherche ne donnant aucun résultat")
        
        // Data binding
        viewModel.callback = { type in
            switch type {
            case .reload:
                XCTFail()
            case .failure(let error):
                expectation2.fulfill()
                XCTAssertEqual(error, "Aucune annonce disponible pour l'élément recherché: iPhone X")
            }
        }
        
        viewModel.getItems()
        expectation1.fulfill()
        
        viewModel.searchItems(query: "iPhone X")
        wait(for: [expectation1, expectation2], timeout: 10)
    }
    
    func testItemCellViewModel() {
        let viewModel = ItemCellViewModel(itemProduct: Product(id: 1701862400, categoryID: 8, title: "iPhone 13 Pro Max 1 TB", productDescription: "iPhone 13 Pro Max couleur Bleu Alpin, capacité de stockage 1 TB, neuf sous blister avec facture.", price: 1300, imagesURL: ImagesURL(small: "https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/iphone-13-pro-blue-select?wid=470&hei=556&fmt=jpeg&qlt=95&.v=1631652954000", thumb: "https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/iphone-13-pro-blue-select?wid=470&hei=556&fmt=jpeg&qlt=95&.v=1631652954000"), creationDate: "2021-11-10T21:53:38+0000", isUrgent: true, siret: nil), itemCategory: "Multimédia")
        
        XCTAssertEqual(viewModel.itemAddedDate, "Le 10/11/2021 à 22:53")
    }
}
