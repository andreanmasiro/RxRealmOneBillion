//
//  CountryListViewModelTest.swift
//  RxRxRealmTests
//
//  Created by André Marques da Silva Rodrigues on 01/01/18.
//  Copyright © 2018 Vergil. All rights reserved.
//

import XCTest
import RxBlocking
import RxSwift
import RealmSwift
import RxRealm

@testable import RxRxRealm

class CountryListViewModelTest: XCTestCase {
  
  let realmProvider = TestRealmProvider()
  var viewModel: CountryListViewModel!
  
  override func setUp() {
    
    let service = CountryService(realmProvider: realmProvider)
    viewModel = CountryListViewModel(service: service)

    super.setUp()
  }
  
  func testCreateCountry() {
    
    let (name, acronym) = ("some name", "ABC")
    
    guard case let country?? = try? viewModel.createCountry(name: name, acronym: acronym).toBlocking().first() else {
      
      XCTFail("failed creating country")
      return
    }
    
    XCTAssertEqual(country.name, name, "created country name should match with the passed one")
    XCTAssertEqual(country.acronym, acronym, "created country acronym should match with the passed one")
    
    do {
      
      let persistedObject = try realmProvider.realm().object(ofType: Country.self, forPrimaryKey: country.uid)
      
      XCTAssertNotNil(persistedObject, "object should be persisted in realm")
      
    } catch {
      XCTFail("failed instantiating realm " + error.localizedDescription)
    }
    
  }
  
}
