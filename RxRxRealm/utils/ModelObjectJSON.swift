//
//  ModelObjectJSONEncoder.swift
//  RxRxRealm
//
//  Created by André Marques da Silva Rodrigues on 26/12/17.
//  Copyright © 2017 Vergil. All rights reserved.
//

import Foundation

struct ModelObjectJSON {
  
  static var decoder: JSONDecoder {
    
    let decoder = JSONDecoder()
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    
    decoder.dateDecodingStrategy = .formatted(dateFormatter)
    
    return decoder
  }
  
  static var encoder: JSONEncoder {
    
    let encoder = JSONEncoder()
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    
    encoder.dateEncodingStrategy = .formatted(dateFormatter)
    
    return encoder
  }
}
