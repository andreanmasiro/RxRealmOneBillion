//
//  CountryTest.swift
//  RxRxRealmTests
//
//  Created by André Marques da Silva Rodrigues on 03/01/18.
//  Copyright © 2018 Vergil. All rights reserved.
//

import XCTest

@testable import RxRxRealm

class CountryTest: XCTestCase {
  
  override func setUp() {
    super.setUp()
  }
  
  func testInitFromCodableRepresentation() {
    
    let initData = (
      uid: "some uid",
      createdAt: Date(),
      updatedAt: Date(),
      deletedAt: Date?(nilLiteral: ()),
      name: "some name",
      acronym: "ABC"
    )
    
    let codableRepresentation = Country.CodableRepresentation(
      uid: initData.uid,
      createdAt: initData.createdAt,
      updatedAt: initData.updatedAt,
      deletedAt: initData.deletedAt,
      name: initData.name,
      acronym: initData.acronym
    )
    do {
      let country = try Country(codableRepresentation: codableRepresentation)
      
      XCTAssertEqual(country.uid, codableRepresentation.uid,
                     "country should have same uid as codable representation")
      XCTAssertEqual(country.createdAt, codableRepresentation.createdAt,
                     "country should have same createdAt as codable representation")
      XCTAssertEqual(country.updatedAt, codableRepresentation.updatedAt,
                     "country should have same updatedAt as codable representation")
      XCTAssertEqual(country.deletedAt, codableRepresentation.deletedAt,
                     "country should have same deletedAt as codable representation")
      XCTAssertEqual(country.name, codableRepresentation.name,
                     "country should have same name as codable representation")
      XCTAssertEqual(country.acronym, codableRepresentation.acronym,
                     "country should have same acronym as codable representation")
    } catch {
      XCTFail("failed initializing country with error: \(error.localizedDescription)")
    }
  }
  
  func testInitCodableRepresentationWithCountry() {
    
    let initData = (
      uid: "some uid",
      createdAt: Date(),
      updatedAt: Date(),
      deletedAt: Date?(nilLiteral: ()),
      name: "some name",
      acronym: "ABC"
    )
    
    let country = Country()
    country.uid = initData.uid
    country.createdAt = initData.createdAt
    country.updatedAt = initData.updatedAt
    country.deletedAt = initData.deletedAt
    country.name = initData.name
    country.acronym = initData.acronym
    
    let cr = Country.CodableRepresentation(country: country)
    
    XCTAssertEqual(country.uid, cr.uid,
                   "codable representation should have same uid as country")
    XCTAssertEqual(country.createdAt, cr.createdAt,
                   "codable representation should have same createdAt as country")
    XCTAssertEqual(country.updatedAt, cr.updatedAt,
                   "codable representation should have same updatedAt as country")
    XCTAssertEqual(country.deletedAt, cr.deletedAt,
                   "codable representation should have same deletedAt as country")
    XCTAssertEqual(country.name, cr.name,
                   "codable representation should have same name as country")
    XCTAssertEqual(country.acronym, cr.acronym,
                   "codable representation should have same acronym as country")
  }
}
