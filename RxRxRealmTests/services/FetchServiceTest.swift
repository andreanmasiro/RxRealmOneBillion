//
//  FetchServiceTEst.swift
//  RxRxRealmTests
//
//  Created by André Marques da Silva Rodrigues on 04/01/18.
//  Copyright © 2018 Vergil. All rights reserved.
//

import XCTest
import RxBlocking
import RxSwift
import RealmSwift

@testable import RxRxRealm

class FetchServiceTest: XCTestCase {
  
  var countryService: CountryService!
  var cityService: CityService!
  var fetchService: FetchService!
  
  var dummyCountry: Country {
    
    let country = Country()
    country.name = "some name"
    country.acronym = "ABC"
    
    return country
  }
  
  var dummyCity: City {
    
    let city = City()
    city.name = "some city name"
    
    return city
  }
  
  override func setUp() {
    
    let realmProvider = DefaultRealmProvider()
    countryService = CountryService(realmProvider: realmProvider)
    cityService = CityService(realmProvider: realmProvider)
    fetchService = FetchService(realmProvider: realmProvider)
  }
  
  func testCountryWithUid() {
    
    let country = dummyCountry
    
    _ = countryService.create(object: country).toBlocking().materialize()
    
    do {
      let fetchedCountry = try fetchService
        .object(type: Country.self, withUid: country.uid)
      
      XCTAssertEqual(country, fetchedCountry, "fetched country should be the same as the created one")
    } catch {
      
      XCTFail("failed fetching country with error:\(error.localizedDescription)")
    }
  }
  
  func testCityWithUid() {
    
    let country = dummyCountry
    _ = countryService.create(object: country).toBlocking().materialize()
    
    let city = dummyCity
    city.country = country
    _ = cityService.create(object: city).toBlocking().materialize()
    
    do {
      let fetchedCity = try fetchService
        .object(type: City.self, withUid: city.uid)
      
      XCTAssertEqual(city, fetchedCity, "fetched city should be the same as the created one")
    } catch {
      
      XCTFail("failed fetching city with error:\(error.localizedDescription)")
    }
  }
  
  func testFetchInvalidUid() {
    
    let invalidUid = "invalid uid"
    do {
      _ = try fetchService.object(type: Country.self, withUid: invalidUid)
    } catch ServiceError.fetchingByIdFailed(let uid) {
      
      XCTAssertEqual(invalidUid, uid, "uid retrieved by the error should be the same as the one passed to the fetch method")
    } catch {
      
      XCTFail("failed due to unexpected error: \(error.localizedDescription)")
    }
  }
}
