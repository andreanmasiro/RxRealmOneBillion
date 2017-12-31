//
//  CountryService.swift
//  RxRxRealm
//
//  Created by André Marques da Silva Rodrigues on 23/12/17.
//  Copyright © 2017 Vergil. All rights reserved.
//

import RxSwift
import RealmSwift

struct CountryService: CountryServiceType {
  
  private let service: ModelObjectService<Country>
  
  init(realmProvider: RealmProviderType) {
    
    service = ModelObjectService(realmProvider: realmProvider)
  }
  
  @discardableResult
  func create(object: Country) -> Observable<Country> {
    return service.create(object: object)
  }
  
  func allObjects(getDeleted: Bool) -> Observable<[Country]> {
    return service.allObjects(getDeleted: getDeleted)
      .map { $0.toArray() }
  }
  
  @discardableResult
  func delete(object: Country) -> Completable {
    return service.delete(object: object)
  }
  
  func update(object: Country, updateClosure: () -> ()) -> Observable<Country> {
    return service.update(object: object, updateClosure: updateClosure)
  }
}
