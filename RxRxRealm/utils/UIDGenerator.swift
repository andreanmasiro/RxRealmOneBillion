//
//  UIDGenerator.swift
//  RxRxRealm
//
//  Created by André Marques da Silva Rodrigues on 22/12/17.
//  Copyright © 2017 Vergil. All rights reserved.
//

import UIKit

struct UIDGenerator {
  
  static func uniqueId(length: Int) -> String {
    
    let lowercaseLetters = "abcdefghijklmnopqrstuvwxyz".map { String($0) }
    let uppercaseLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".map { String($0) }
    let numbers = "0123456789".map { String($0) }
    
    var code = ""
    for _ in 0..<length {
      
      let c = Int(arc4random_uniform(62))
      
      switch c {
      case 0..<26:
        code.append(lowercaseLetters[c]) // lowercase letters
      case 26..<52:
        code.append(uppercaseLetters[c - 26]) // uppercase letters
      default:
        code.append(numbers[c - 52]) // numbers
      }
    }
    
    return code
  }
}
