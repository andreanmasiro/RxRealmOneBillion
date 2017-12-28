//
//  CityServiceType.swift
//  RxRxRealm
//
//  Created by André Marques da Silva Rodrigues on 24/12/17.
//  Copyright © 2017 Vergil. All rights reserved.
//

import RxSwift
import RealmSwift

protocol CityServiceType {
  
  @discardableResult
  func create(object: City) -> Observable<City>
  
  func allObjects(country: Country?, getDeleted: Bool)  -> Observable<[City]>
  
  @discardableResult
  func delete(object: City) -> Completable
  
  func update(object: City, updateClosure: () -> ()) -> Observable<City>
}

extension CityServiceType {
  
  func allObjects(getDeleted: Bool) -> Observable<[City]> {
    return allObjects(country: nil, getDeleted: getDeleted)
  }
  
  func allObjects() -> Observable<[City]> {
    return allObjects(country: nil, getDeleted: false)
  }
  
  func allObjects(country: Country?) -> Observable<[City]> {
    return allObjects(country: country, getDeleted: false)
  }
}
