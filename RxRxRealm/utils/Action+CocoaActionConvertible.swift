//
//  Action+CocoaActionConvertible.swift
//  RxRxRealm
//
//  Created by André Marques da Silva Rodrigues on 02/01/18.
//  Copyright © 2018 Vergil. All rights reserved.
//

import Action
import RxSwift

extension Action where Input == Void {
  
  var cocoaAction: CocoaAction {
    return CocoaAction {
      self.execute(()).map { _ in }
    }
  }
}
