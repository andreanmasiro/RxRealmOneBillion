//
//  TestRealmProvider.swift
//  RxRxRealmTests
//
//  Created by André Marques da Silva Rodrigues on 28/12/17.
//  Copyright © 2017 Vergil. All rights reserved.
//

import RealmSwift

@testable
import RxRxRealm

struct TestRealmProvider: RealmProviderType {
  
  func realm() throws -> Realm {
    
    var config = Realm.Configuration()
    config.inMemoryIdentifier = "modelObjectServiceTest"
    return try Realm(configuration: config)
  }
}
