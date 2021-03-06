//
//  CityService.swift
//  RxRxRealm
//
//  Created by André Marques da Silva Rodrigues on 24/12/17.
//  Copyright © 2017 Vergil. All rights reserved.
//

import RxSwift
import RealmSwift

struct CityService: CityServiceType {
  
  private let service: ModelObjectService<City>
  
  init(realmProvider: RealmProviderType) {
    
    service = ModelObjectService(realmProvider: realmProvider)
  }
  
  @discardableResult
  func create(object: City) -> Observable<City> {
    return service.create(object: object)
  }
  
  func allObjects(country: Country?, getDeleted: Bool) -> Observable<[City]> {
    
    let filterClosure: ((Results<City>) -> Results<City>)?
    if let country = country {
      
      filterClosure = { $0.filter("country == %@", country) }
    } else { filterClosure = nil }
    
    return service
      .allObjects(getDeleted: getDeleted,
                  filterClosure: filterClosure)
      .map { $0.toArray() }
  }
  
  @discardableResult
  func delete(object: City) -> Completable {
    return service.delete(object: object)
  }
  
  func update(object: City, updateClosure: () -> ()) -> Observable<City> {
    return service.update(object: object, updateClosure: updateClosure)
  }
}
