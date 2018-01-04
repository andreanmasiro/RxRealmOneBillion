//
//  FakeCityService.swift
//  RxRxRealmTests
//
//  Created by André Marques da Silva Rodrigues on 02/01/18.
//  Copyright © 2018 Vergil. All rights reserved.
//

import RxSwift

@testable import RxRxRealm

fileprivate var objects = [City]()
struct FakeCityService: CityServiceType {
  
  init() {
    objects = []
  }
  
  func create(object: City) -> Observable<City> {
    objects.append(object)
    return Observable.just(object)
  }
  
  func allObjects(country: Country?, getDeleted: Bool) -> Observable<[City]> {
    
    let allObjects = objects
      .filter { (country == nil) || ($0.country == country) }
      .filter { getDeleted || $0.country.deletedAt == nil }
    
    return Observable.just(allObjects)
  }
  
  func delete(object: City) -> Completable {
    objects.first { $0 == object }?.deletedAt = Date()
    return Completable.empty()
  }
  
  func update(object: City, updateClosure: () -> ()) -> Observable<City> {
    updateClosure()
    return Observable.just(object)
  }
}

extension FakeFetchService {
  
  func city(uid: String) -> City? {
    return objects.first { $0.uid == uid }
  }
}

