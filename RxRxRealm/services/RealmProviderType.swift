//
//  RealmProviderType.swift
//  RxRxRealm
//
//  Created by André Marques da Silva Rodrigues on 28/12/17.
//  Copyright © 2017 Vergil. All rights reserved.
//

import RealmSwift

protocol RealmProviderType {
  
  func realm() throws -> Realm
}
