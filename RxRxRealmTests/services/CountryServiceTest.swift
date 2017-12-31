//
//  CountryServiceTest.swift
//  RxRxRealmTests
//
//  Created by André Marques da Silva Rodrigues on 31/12/17.
//  Copyright © 2017 Vergil. All rights reserved.
//

import XCTest
import RxBlocking
import RxSwift
import RealmSwift
import RxRealm

@testable import RxRxRealm

class CountryServiceTest: XCTestCase {

  var service: CountryService!
  var dummy: Country {
    let country = Country()
    country.name = "Some country"
    country.acronym = "ABC"
    
    return country
  }
  override func setUp() {
    service = CountryService(realmProvider: TestRealmProvider())
    super.setUp()
  }
  
  func testCreate() {
    
    let country = dummy
    
    _ = service.create(object: country).toBlocking().materialize()
    
    XCTAssertNotNil(country.uid, "created object has uid")
    XCTAssertNotNil(country.createdAt, "created object has createdAt")
    XCTAssertNotNil(country.updatedAt, "created object has updatedAt")
  }
  
  func testDelete() {
    
    let country = dummy
    
    _ = service.create(object: country).toBlocking().materialize()
    
    _ = service.delete(object: country).toBlocking().materialize()
    
    XCTAssertNotNil(country.deletedAt,
                    "deleted object should have deletedAt")
  }
  
  func testUpdate() {
    
    let country = dummy
    
    _ = service.create(object: country).toBlocking().materialize()
    
    let newCountryName = "some other country"
    let newCountryAcronym = "new acronym"
    _ = service.update(object: country) {
      country.name = newCountryName
      country.acronym = newCountryAcronym
    }
      .toBlocking().materialize()
    
    XCTAssertEqual(country.name, newCountryName)
    XCTAssertEqual(country.acronym, newCountryAcronym)
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
  
}
