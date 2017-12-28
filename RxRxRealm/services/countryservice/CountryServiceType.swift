//
//  CountryServiceType.swift
//  RxRxRealm
//
//  Created by André Marques da Silva Rodrigues on 23/12/17.
//  Copyright © 2017 Vergil. All rights reserved.
//

import RxSwift
import RealmSwift

protocol CountryServiceType {
  
  @discardableResult
  func create(object: Country) -> Observable<Country>
  
  func allObjects(getDeleted: Bool) -> Observable<[Country]>
  
  @discardableResult
  func delete(object: Country) -> Completable
  
  func update(object: Country, updateClosure: () -> ()) -> Observable<Country>
}

extension CountryServiceType {
  
  func allObjects() -> Observable<[Country]> {
    return allObjects(getDeleted: false)
  }
}
