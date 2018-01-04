//
//  FetchServiceType.swift
//  RxRxRealm
//
//  Created by André Marques da Silva Rodrigues on 03/01/18.
//  Copyright © 2018 Vergil. All rights reserved.
//

import Foundation

protocol FetchServiceType {
  
  func object<T: ModelObject>(type: T.Type, withUid uid: String) throws -> T
}
