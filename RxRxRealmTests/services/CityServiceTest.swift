//
//  CityServiceTest.swift
//  RxRxRealmTests
//
//  Created by André Marques da Silva Rodrigues on 31/12/17.
//  Copyright © 2017 Vergil. All rights reserved.
//

import XCTest
import RxBlocking
import RxSwift
import RealmSwift

@testable import RxRxRealm

class CityServiceTest: XCTestCase {

  let realmProvider = TestRealmProvider()
  var service: CityService!
  var countryService: CountryService!
  
  
  var dummy: City {
    let city = City()
    city.name = "some city"
    
    return city
  }
  
  var dummyCountry: Country {
    
    let country = Country()
    country.name = "some name"
    country.acronym = "ABC"
    
    return country
  }
  
  override func setUp() {
    service = CityService(realmProvider: realmProvider)
    countryService = CountryService(realmProvider: realmProvider)
    super.setUp()
  }
  
  func testCreate() {
    
    let city = dummy
    
    _ = service.create(object: city).toBlocking().materialize()
    
    XCTAssertNotNil(city.uid, "created object has uid")
    XCTAssertNotNil(city.createdAt, "created object has createdAt")
    XCTAssertNotNil(city.updatedAt, "created object has updatedAt")
    XCTAssertNil(city.deletedAt, "created object has no deletedAt")
    
    do {
      let persistedObject = try realmProvider
        .realm()
        .object(ofType: City.self, forPrimaryKey: city.uid)
      
      XCTAssertNotNil(persistedObject)
    } catch {
      XCTFail("failed instaintiating realm " + error.localizedDescription)
    }
  }
  
  func testDelete() {
    
    let city = dummy
    
    _ = service.create(object: city).toBlocking().materialize()
    
    _ = service.delete(object: city).toBlocking().materialize()
    
    XCTAssertNotNil(city.deletedAt,
                    "deleted object should have deletedAt")
  }
  
  func testUpdate() {
    
    let city = dummy
    
    _ = service.create(object: city).toBlocking().materialize()
    
    let newCityName = "some other city"
    _ = service.update(object: city) {
      city.name = newCityName
      }
      .toBlocking().materialize()
    
    XCTAssertEqual(city.name, newCityName)
  }
  
  func testGetAll() {
    
    let dummies = [dummy, dummy, dummy]
    dummies.forEach {
      _ = self.service.create(object: $0).toBlocking().materialize()
    }
    
    let fetchedDummies = try! service.allObjects().toBlocking().first()!
    
    XCTAssertEqual(dummies, fetchedDummies)
  }
  
  func testGetAll_getDeleted() {
    
    let dummies = [dummy, dummy, dummy]
    dummies.forEach {
      _ = self.service.create(object: $0).toBlocking().materialize()
    }
    
    service.delete(object: dummies[2])
    
    guard case let nonDeletedDummies?? = try? service.allObjects().toBlocking().first() else {
      XCTFail("failed fetching objects")
      return
    }
    
    XCTAssertEqual(Array(dummies[..<2]), nonDeletedDummies)
    
    guard case let allDummies?? = try? service.allObjects(getDeleted: true).toBlocking().first() else {
      XCTFail("failed fetching objects")
      return
    }
    
    XCTAssertEqual(dummies, allDummies)
  }
  
  func testGetAllByCountry() {
    
    guard case let country1?? = try? countryService.create(object: dummyCountry).toBlocking().first() else {
      XCTFail("failed creating country")
      return
    }
    
    guard case let country2?? = try? countryService.create(object: dummyCountry).toBlocking().first() else {
      XCTFail("failed creating country")
      return
    }
    
    let dummies1 = (0..<3).map { _ -> City in
      let city = self.dummy
      city.country = country1
      return city
    }
    let dummies2 = (0..<3).map { _ -> City in
      let city = self.dummy
      city.country = country2
      return city
    }
    
    dummies1.forEach { _ = service.create(object: $0).toBlocking().materialize() }
    dummies2.forEach { _ = service.create(object: $0).toBlocking().materialize() }
    
    guard case let fetchedDummies1?? = try? service.allObjects(country: country1)
      .toBlocking().first() else {
        XCTFail("failed fetching cities")
        return
    }
    guard case let fetchedDummies2?? = try? service.allObjects(country: country2)
      .toBlocking().first() else {
        XCTFail("failed fetching cities")
        return
    }
    
    XCTAssertEqual(fetchedDummies1, dummies1)
    XCTAssertEqual(fetchedDummies2, dummies2)
  }

}
