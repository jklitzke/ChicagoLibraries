//
//  ChicagoLibrariesTests.swift
//  ChicagoLibrariesTests
//
//  Created by James Klitzke on 1/28/17.
//  Copyright © 2017 James Klitzke. All rights reserved.
//

import XCTest
@testable import ChicagoLibraries

class MasterViewControllerTests: XCTestCase {
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    var viewController : MasterViewController = MasterViewController()
    
    override func setUp() {
        super.setUp()
        
        viewController = storyboard.instantiateViewController(withIdentifier: "Master") as! MasterViewController
        viewController.cityOfChicagoServices = CityOfChicagoServicesMock()
        viewController.viewDidLoad()
    }
    
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testTableView_WithTwoLibraries_ShouldContainTwoRows() {
        XCTAssertEqual(viewController.tableView(viewController.tableView, numberOfRowsInSection: 0), 2)
    }
    
    func testTableViewCell_WithValidLibrary_ShouldShowLibraryName() {
        
        let cell = viewController.tableView(viewController.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        
        XCTAssertEqual(cell.textLabel?.text, "Test Library 1")
    }
    
    
}

class DetailViewControllerTests: XCTestCase {
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    var viewController : DetailViewController = DetailViewController()
    
    override func setUp() {
        super.setUp()
        
        viewController = storyboard.instantiateViewController(withIdentifier: "LibraryDetail") as! DetailViewController
        viewController.library = CityOfChicagoServicesMock.mockLibrary1()
        viewController.loadView()   
        viewController.viewDidLoad()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testDetailScreen_ShowValidLibary_ShouldDisplayBasicLibraryInfo() {
        XCTAssertEqual(viewController.libraryNameLabel.text, "Test Library 1")
        XCTAssertEqual(viewController.libraryAddressLabel.text, "1234 Main Street")
        XCTAssertEqual(viewController.libraryHoursLabel.text, "No Hours Of Operation")

    }
}
