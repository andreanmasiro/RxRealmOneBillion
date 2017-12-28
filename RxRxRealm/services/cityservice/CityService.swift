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
  
  private let service = ModelObjectService<City>(realmProvider: DefaultRealmProvider())
  
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
      .allObjects(City.self,
                  getDeleted: getDeleted,
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
