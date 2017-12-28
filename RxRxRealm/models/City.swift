//
//  City.swift
//  RxRxRealm
//
//  Created by André Marques da Silva Rodrigues on 23/12/17.
//  Copyright © 2017 Vergil. All rights reserved.
//

import Foundation
import RealmSwift

class City: ModelObject {

  @objc dynamic var name: String!
  @objc dynamic var country: Country!
  
  var codableRepresentation: CodableRepresentation {
    return CodableRepresentation(city: self)
  }
  
  override class var codableRepresentationType: Any.Type {
    return CodableRepresentation.self
  }
  
  struct CodableRepresentation: Codable {
    
    let uid: String
    let createdAt: Date
    let updatedAt: Date
    let deletedAt: Date?
    let name: String
    let country_id: String
    
    init(city: City) {
      
      uid = city.uid
      createdAt = city.createdAt
      updatedAt = city.updatedAt
      deletedAt = city.deletedAt
      name = city.name
      country_id = city.country.uid
    }
  }
}
