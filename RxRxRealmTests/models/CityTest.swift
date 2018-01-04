//
//  CityTest.swift
//  RxRxRealmTests
//
//  Created by André Marques da Silva Rodrigues on 03/01/18.
//  Copyright © 2018 Vergil. All rights reserved.
//

import XCTest

@testable import RxRxRealm

class CityTest: XCTestCase {
  
  var country: Country!
  var countryService: FakeCountryService!
  
  override func setUp() {
    
    country = Country()
    country.uid = "some countrish uid"
    
    countryService = FakeCountryService()
    countryService.create(object: country)
    super.setUp()
  }
  
  func testInitFromCodableRepresentation() {
    
    let initData = (
      uid: "some uid",
      createdAt: Date(),
      updatedAt: Date(),
      deletedAt: Date?(nilLiteral: ()),
      name: "some name",
      country: country
    )
    
    let codableRepresentation = City.CodableRepresentation(
      uid: initData.uid,
      createdAt: initData.createdAt,
      updatedAt: initData.updatedAt,
      deletedAt: initData.deletedAt,
      name: initData.name,
      country: initData.country
    )
    do {
      let city = try City(codableRepresentation: codableRepresentation, fetchService: FakeFetchService())
      
      XCTAssertEqual(city.uid, codableRepresentation.uid,
                     "city should have same uid as codable representation")
      XCTAssertEqual(city.createdAt, codableRepresentation.createdAt,
                     "city should have same createdAt as codable representation")
      XCTAssertEqual(city.updatedAt, codableRepresentation.updatedAt,
                     "city should have same updatedAt as codable representation")
      XCTAssertEqual(city.deletedAt, codableRepresentation.deletedAt,
                     "city should have same deletedAt as codable representation")
      XCTAssertEqual(city.name, codableRepresentation.name,
                     "city should have same name as codable representation")
      XCTAssertEqual(city.country.uid, codableRepresentation.country_id,
                     "city country should have same uid as codable representation")
    } catch {
      XCTFail("failed initializing city with error: \(error.localizedDescription)")
    }
  }
  
  func testInitCodableRepresentationWithCity() {
    
    let initData = (
      uid: "some uid",
      createdAt: Date(),
      updatedAt: Date(),
      deletedAt: Date?(nilLiteral: ()),
      name: "some name",
      acronym: "ABC"
    )
    
    let city = City()
    city.uid = initData.uid
    city.createdAt = initData.createdAt
    city.updatedAt = initData.updatedAt
    city.deletedAt = initData.deletedAt
    city.name = initData.name
    city.country = country
    
    let cr = City.CodableRepresentation(city: city)
    
    XCTAssertEqual(city.uid, cr.uid,
                   "codable representation should have same uid as city")
    XCTAssertEqual(city.createdAt, cr.createdAt,
                   "codable representation should have same createdAt as city")
    XCTAssertEqual(city.updatedAt, cr.updatedAt,
                   "codable representation should have same updatedAt as city")
    XCTAssertEqual(city.deletedAt, cr.deletedAt,
                   "codable representation should have same deletedAt as city")
    XCTAssertEqual(city.name, cr.name,
                   "codable representation should have same name as city")
    XCTAssertEqual(city.country.uid, cr.country_id,
                   "codable representation should have same acronym as city")
  }
}
