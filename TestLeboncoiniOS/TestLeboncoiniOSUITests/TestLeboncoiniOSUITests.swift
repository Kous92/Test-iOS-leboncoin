//
//  TestLeboncoiniOSUITests.swift
//  TestLeboncoiniOSUITests
//
//  Created by Koussaïla Ben Mamar on 02/10/2021.
//

import XCTest

class TestLeboncoiniOSUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMain() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        print(app.debugDescription)
        XCTAssertTrue(app.otherElements["searchBar"].exists, "La barre de recherche n'existe pas.")
        let tableView = app.tables["mainTableView"]
        XCTAssertTrue(tableView.exists, "Le TableView des annonces n'existe pas")
        XCTAssertTrue(app.buttons["filterButton"].exists, "Le bouton de filtrage n'existe pas.")
        
        app.swipeUp()
        app.swipeDown()
    }

    func testFilterView() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        app.buttons["filterButton"].tap()
        print(app.debugDescription)
        XCTAssertTrue(app.staticTexts["Catégories"].exists)
        let tableView = app.tables["filterTableView"]
        XCTAssertTrue(tableView.exists, "Le TableView des catégories n'existe pas")
        XCTAssertTrue(app.buttons["filterCloseButton"].exists, "Le bouton de filtrage n'existe pas.")
        
        let cells = tableView.cells
        XCTAssertGreaterThanOrEqual(cells.count, 0)
        
        if cells.count > 0 {
            let promise = expectation(description: "En attente des TableViewCells")
            
            // On pointe sur la première cellule
            let category = cells.element(boundBy: 0)
            XCTAssertTrue(category.exists, "La cellule n'existe pas")
            promise.fulfill()
            waitForExpectations(timeout: 10, handler: nil)
            XCTAssertTrue(true, "Échec.")
            category.tap()
         
        } else {
            XCTAssert(false, "Pas de cellules disponibles")
        }
        
        app.buttons["filterCloseButton"].tap()
    }
    
    func testSearchProducts() throws {
        let app = XCUIApplication()
        app.launch()
        
        print(app.debugDescription)
        let searchBar = app.otherElements["searchBar"]
        XCTAssertTrue(searchBar.exists, "La barre de recherche n'existe pas.")
        let tableView = app.tables["mainTableView"]
        XCTAssertTrue(tableView.exists, "Le TableView des annonces n'existe pas")
        XCTAssertTrue(app.buttons["filterButton"].exists, "Le bouton de filtrage n'existe pas.")
        
        searchBar.tap()
        searchBar.typeText("iPhone")
        XCTAssertTrue(app.keyboards.buttons["Search"].waitForExistence(timeout: 2.0))
        app.keyboards.buttons["Search"].tap()
        
        let cells = tableView.cells
        XCTAssertGreaterThanOrEqual(cells.count, 0)
    }
    
    func testProductDetails() throws {
        let app = XCUIApplication()
        app.launch()
        
        print(app.debugDescription)
        let searchBar = app.otherElements["searchBar"]
        XCTAssertTrue(searchBar.exists, "La barre de recherche n'existe pas.")
        let tableView = app.tables["mainTableView"]
        XCTAssertTrue(tableView.exists, "Le TableView des annonces n'existe pas")
        XCTAssertTrue(app.buttons["filterButton"].exists, "Le bouton de filtrage n'existe pas.")
        
        let cells = tableView.cells
        XCTAssertGreaterThanOrEqual(cells.count, 0)
        
        if cells.count > 0 {
            let promise = expectation(description: "En attente des TableViewCells")
            
            // On pointe sur la première cellule
            let product = cells.element(boundBy: 0)
            XCTAssertTrue(product.exists, "La cellule n'existe pas")
            promise.fulfill()
            waitForExpectations(timeout: 10, handler: nil)
            XCTAssertTrue(true, "Échec.")
            product.tap()
         
        } else {
            XCTAssert(false, "Pas de cellules disponibles")
        }
        
        // Seconde vue
        XCTAssertTrue(app.scrollViews["scrollView"].exists)
        XCTAssertTrue(app.buttons["closeButton"].exists, "Le bouton de fermeture n'existe pas.")
        
        app.swipeUp()
        app.swipeDown()
        
        app.buttons["closeButton"].tap()
    }
}
