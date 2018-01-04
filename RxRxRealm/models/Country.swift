//
//  Country.swift
//  RxRxRealm
//
//  Created by André Marques da Silva Rodrigues on 22/12/17.
//  Copyright © 2017 Vergil. All rights reserved.
//

import Foundation
import RealmSwift

class Country: ModelObject {
  
  @objc dynamic var name: String!
  @objc dynamic var acronym: String!
  
  var codableRepresentation: CodableRepresentation {
    return CodableRepresentation(country: self)
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
    let acronym: String
    
    init(uid: String,
         createdAt: Date,
         updatedAt: Date,
         deletedAt: Date?,
         name: String,
         acronym: String) {
      
      self.uid = uid
      self.createdAt = createdAt
      self.updatedAt = updatedAt
      self.deletedAt = deletedAt
      self.name = name
      self.acronym = acronym
    }
    
    init(country: Country) {
      
      uid = country.uid
      createdAt = country.createdAt
      updatedAt = country.updatedAt
      deletedAt = country.deletedAt
      name = country.name
      acronym = country.acronym
    }
  }
}
