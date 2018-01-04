//
//  FakeFetchService.swift
//  RxRxRealmTests
//
//  Created by André Marques da Silva Rodrigues on 03/01/18.
//  Copyright © 2018 Vergil. All rights reserved.
//

@testable import RxRxRealm

struct FakeFetchService: FetchServiceType {
  
  func object<T: ModelObject>(type: T.Type, withUid uid: String) throws -> T {
    
    if type == City.self {
      
      guard let city = city(uid: uid) else {
        throw ServiceError.fetchingByIdFailed(uid)
      }
      return city as! T
    } else if type == Country.self {
      
      guard let country = country(uid: uid) else {
        throw ServiceError.fetchingByIdFailed(uid)
      }
      return country as! T
    } else {
      throw ServiceError.fetchingByIdFailed(uid)
    }
  }
}
