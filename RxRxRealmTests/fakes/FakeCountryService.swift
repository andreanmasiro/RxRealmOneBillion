//
//  FakeContryService.swift
//  RxRxRealmTests
//
//  Created by André Marques da Silva Rodrigues on 02/01/18.
//  Copyright © 2018 Vergil. All rights reserved.
//

import RxSwift

@testable import RxRxRealm

fileprivate var objects = [Country]()
struct FakeCountryService: CountryServiceType {
  
  init() {
    objects = []
  }
  
  func allObjects(getDeleted: Bool) -> Observable<[Country]> {
    return Observable.just(objects)
  }
  
  func create(object: Country) -> Observable<Country> {
    objects.append(object)
    return Observable.just(object)
  }
  
  func delete(object: Country) -> Completable {
    objects.first { $0 == object }?.deletedAt = Date()
    return Completable.empty()
  }
  
  func update(object: Country, updateClosure: () -> ()) -> Observable<Country> {
    updateClosure()
    return Observable.just(object)
  }
}
