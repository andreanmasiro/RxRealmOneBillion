//
//  ModelObject.swift
//  RxRxRealm
//
//  Created by André Marques da Silva Rodrigues on 22/12/17.
//  Copyright © 2017 Vergil. All rights reserved.
//

import Foundation
import RealmSwift
import RxDataSources

enum ModelObjectError: Error {
  
  // codable representation init
  case invalidCodableRepresentation(Any)
  case associatedObjectNotFound(String)
  case invalidProperty(String)
  
  // model type from string
  case invalidModelType(String)
}

class ModelObject: Object {
  
  @objc dynamic var uid: String!
  @objc dynamic var createdAt: Date!
  @objc dynamic var updatedAt: Date!
  @objc dynamic var deletedAt: Date?
  
  @objc override class func primaryKey() -> String? {
    return "uid"
  }
  
  class var codableRepresentationType: Any.Type {
    return Any.self
  }
  
  class func modelType(fromString str: String) throws -> ModelObject.Type {
    
    switch str.uppercased() {
      
    case "COUNTRY": return Country.self
    case "CITY": return City.self
    default: throw ModelObjectError.invalidModelType(str)
    }
  }
  
  convenience init(codableRepresentation: Any,
                   fetchService: FetchServiceType) throws {
    
    self.init()
    
    let t = type(of: codableRepresentation)
    let selfT = type(of: self).codableRepresentationType
    guard t == selfT else {
      throw ModelObjectError
        .invalidCodableRepresentation(codableRepresentation)
    }
    
    let mirror = Mirror(reflecting: codableRepresentation)
    
    for case let (key?, value) in mirror.children {
      
      let valueMirror = Mirror(reflecting: value)
      if case .optional? = valueMirror.displayStyle,
        valueMirror.children.count == 0 {
        
        try self.checkResponds(to: key)
        
        setValue(nil, forKey: key)
      } else if key.hasSuffix("_id"),
        let uid = value as? String {
        
        let typeString = String(key.split(separator: "_")[0])
        let type = try ModelObject.modelType(fromString: typeString)
        
        let object = try fetchService.object(type: type, withUid: uid)
        
        try self.checkResponds(to: typeString)
        setValue(object, forKey: typeString)
      } else {
        
        try self.checkResponds(to: key)
        setValue(value, forKey: key)
      }
    }
  }
  
  private func checkResponds(to selectorString: String) throws {
    if !self.responds(to: Selector(selectorString)) {
      throw ModelObjectError.invalidProperty(selectorString)
    }
  }
}

extension ModelObject: IdentifiableType {
  
  var identity: String {
    return uid
  }
}
