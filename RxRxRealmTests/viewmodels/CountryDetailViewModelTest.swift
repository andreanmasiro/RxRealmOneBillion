//
//  CountryDetailViewModelTest.swift
//  RxRxRealmTests
//
//  Created by André Marques da Silva Rodrigues on 02/01/18.
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

class CountryDetailViewModelTest: XCTestCase {
  
  let realmProvider = TestRealmProvider()
  var fakeCountryService: CountryServiceType!
  var fakeCityService: CityServiceType!
  var viewModel: CountryDetailViewModel!
  var country: Country!
  
  override func setUp() {
    
    fakeCountryService = FakeCountryService()
    fakeCityService = FakeCityService()
    
    country = Country()
    country.name = "some name"
    country.acronym = "ABC"
    _ = fakeCountryService.create(object: country).materialize()
    
    viewModel = CountryDetailViewModel(country: country, countryService: fakeCountryService, cityService: fakeCityService)
    
    super.setUp()
  }
  
  func testEditAction() {
    
    let newName = "new name"
    let newAcronym = "new acronym"
    
    _ = viewModel.editAction.execute((newName, newAcronym))
      .toBlocking().materialize()
    
    XCTAssertEqual(newName, country.name, "country name should be updated")
    XCTAssertEqual(newAcronym, country.acronym, "country acronym should be updated")
  }
  
  func testCreateCityAction() {
    
    let cityName = "some city"
    
    guard case let city?? = try? viewModel.createCityAction.execute(cityName)
      .toBlocking().first() else {
        XCTFail("failed creating city")
        return
    }
    
    XCTAssertEqual(city.name, cityName, "created city name should be equal to the name passed as argument")
    XCTAssertEqual(city.country, country, "created city country should be equal to viewmodel's")
    
    guard case let allCities?? = try? fakeCityService.allObjects().toBlocking().first() else {
      
      XCTFail("failed fetching cities")
      return
    }
    
    XCTAssert(allCities.contains(city), "created city should be persisted in service")
  }
  
  func testDeleteCityAction() {
    
    let cityName = "some city"
    
    guard case let city?? = try? viewModel.createCityAction.execute(cityName)
      .toBlocking().first() else {
        XCTFail("failed creating city")
        return
    }
    
    _ = viewModel.deleteCityAction.execute(city)
      .toBlocking().materialize()
    
    XCTAssertNotNil(city.deletedAt, "deleted city should have deletedAt")
  }
  
  func testSectionedCities() {
    
    _ = viewModel.createCityAction.execute("").toBlocking().materialize()
    guard case let section1?? = try? viewModel
      .sectionedCities.toBlocking().first() else {
        XCTFail("failed getting sectioned cities")
        return
    }
    guard case let objects1?? = try? fakeCityService.allObjects(country: country)
      .toBlocking().first() else {
        XCTFail("failed fecthing objects from realm")
        return
    }
    XCTAssertEqual(section1[0].items, objects1, "section's items should be the same as service's items")
    XCTAssertEqual(section1[0].model, "")
    
    
    _ = viewModel.createCityAction.execute("").toBlocking().materialize()
    guard case let section2?? = try? viewModel
      .sectionedCities.toBlocking().first() else {
        XCTFail("failed getting sectioned cities")
        return
    }
    guard case let objects2?? = try? fakeCityService.allObjects(country: country)
      .toBlocking().first() else {
        XCTFail("failed fecthing objects from realm")
        return
    }
    XCTAssertEqual(section2[0].items, objects2, "section's items should be the same as service's items")
    XCTAssertEqual(section2[0].model, "")
  }
}
