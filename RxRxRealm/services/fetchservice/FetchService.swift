//
//  FetchService.swift
//  RxRxRealm
//
//  Created by André Marques da Silva Rodrigues on 03/01/18.
//  Copyright © 2018 Vergil. All rights reserved.
//

import RealmSwift

struct FetchService: FetchServiceType {

  private let realmProvider: RealmProviderType
  
  init(realmProvider: RealmProviderType) {
    self.realmProvider = realmProvider
  }
  
  func object<T: ModelObject>(type: T.Type, withUid uid: String) throws -> T {
    
    let realm = try realmProvider.realm()
    
    guard let object = realm.object(ofType: type, forPrimaryKey: uid) else {
      throw ServiceError.fetchingByIdFailed(uid)
    }
    
    return object
  }
}
