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
import RxCocoa
import RxRealm
import RxDataSources
import Action

@testable import RxRxRealm

class CountryListViewModelTest: XCTestCase {
  
  var fakeCountryService: CountryServiceType!
  var viewModel: CountryListViewModel!
  
  override func setUp() {
    
    fakeCountryService = FakeCountryService()
    viewModel = CountryListViewModel(service: fakeCountryService)

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
    
    guard case let allCountries?? = try? fakeCountryService.allObjects().toBlocking().first() else {
      
      XCTFail("failed fetching countries")
      return
    }
    
    XCTAssert(allCountries.contains(country), "country should be persisted in service")
  }
  
  func testAddAction() {
    
    _ = viewModel.addAction.execute(()).materialize()
    
    guard case let objects?? = try? fakeCountryService
      .allObjects().toBlocking().first() else {
      XCTFail("failed fetching objects")
      return
    }
    
    XCTAssertEqual(objects[0].name, viewModel.defaultName, "created country's name should be default name")
    XCTAssertEqual(objects[0].acronym, viewModel.defaultAcronym, "created country's acronym should be default acronym")
  }
  
  func testDeleteAction() {
    
    let country = Country()
    country.name = "some name"
    country.acronym = "ABC"
    
    _ = fakeCountryService.create(object: country).toBlocking().materialize()
    
    _ = viewModel.deleteAction.execute(country).toBlocking().materialize()
    
    XCTAssertNotNil(country.deletedAt, "deleted country should have deletedAt")
  }
  
  func testSectionedCountries() {
    
    _ = viewModel.addAction.execute(()).toBlocking().materialize()
    guard case let section1?? = try? viewModel
      .sectionedCountries.toBlocking().first() else {
        XCTFail("failed getting sectioned countries")
        return
    }
    guard case let objects1?? = try? fakeCountryService.allObjects()
      .toBlocking().first() else {
        XCTFail("failed fecthing objects from realm")
        return
    }
    XCTAssertEqual(section1[0].items, objects1, "section's items should be the same as service's items")
    XCTAssertEqual(section1[0].model, "")
    
    
    _ = viewModel.addAction.execute(()).toBlocking().materialize()
    guard case let section2?? = try? viewModel
      .sectionedCountries.toBlocking().first() else {
        XCTFail("failed getting sectioned countries")
        return
    }
    guard case let objects2?? = try? fakeCountryService.allObjects()
      .toBlocking().first() else {
        XCTFail("failed fecthing objects from realm")
        return
    }
    XCTAssertEqual(section2[0].items, objects2, "section's items should be the same as service's items")
    XCTAssertEqual(section2[0].model, "")
  }
}
