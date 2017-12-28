//
//  ModelObjectService.swift
//  RxRxRealm
//
//  Created by André Marques da Silva Rodrigues on 22/12/17.
//  Copyright © 2017 Vergil. All rights reserved.
//

import RealmSwift
import RxSwift
import RxRealm

enum ServiceError: Error {
  
  case creationFailed(ModelObject)
  case fetchingFailed
  case deletionFailed(ModelObject)
  case updateFailed(ModelObject)
}

struct ModelObjectService<T: ModelObject> {
  
  private func withRealm<K>(_ operation: String, action: (Realm) throws -> K) -> K? {
    do {
      let realm = try Realm()
      return try action(realm)
    } catch let err {
      print("Failed \(operation) realm with error: \(err)")
      return nil
    }
  }
  
  @discardableResult
  func create(object: T) -> Observable<T> {
    
    let results = withRealm("create") {
      realm -> Observable<T> in
      
      try realm.write {
        object.uid = object.uid ?? UIDGenerator.uniqueId(length: 10)
        
        let now = Date()
        
        object.createdAt = object.createdAt ?? now
        object.updatedAt = object.updatedAt ?? now
        
        realm.add(object)
      }
      
      return Observable.just(object)
    }
    
    return results ?? .error(ServiceError.creationFailed(object))
  }
  
  func allObjects(_ type: T.Type, getDeleted: Bool, filterClosure: ((Results<T>) -> (Results<T>))? = nil) -> Observable<Results<T>> {
    
    let results = withRealm("get all") { realm -> Observable<Results<T>> in
      
      let objects: Results<T>
      if let closure = filterClosure {
        objects = closure(realm.objects(type))
      } else {
        objects = realm.objects(type)
      }
      
      let filteredObjects: Results<T>
      
      if getDeleted {
        filteredObjects = objects
      } else {
        filteredObjects = objects.filter("deletedAt == nil")
      }
      
      return Observable.collection(from: filteredObjects)
    }
    
    return results ?? .error(ServiceError.fetchingFailed)
  }
  
  @discardableResult
  func delete(object: T) -> Completable {
    
    let result = withRealm("delete") { realm -> Completable in
      
      try realm.write {
        object.deletedAt = Date()
        realm.add(object)
      }
      
      return Completable.empty()
    }
    
    return result ?? .error(ServiceError.deletionFailed(object))
  }
  
  func update(object: T, updateClosure: () -> ()) -> Observable<T> {
    
    let result = withRealm("update") { realm -> Observable<T> in
      
      try realm.write {
        
        updateClosure()
        realm.add(object)
      }
      
      return Observable.just(object)
    }
    
    return result ?? .error(ServiceError.updateFailed(object))
  }
}
