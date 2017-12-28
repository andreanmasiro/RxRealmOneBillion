//
//  CountryListViewModel.swift
//  RxRxRealm
//
//  Created by André Marques da Silva Rodrigues on 22/12/17.
//  Copyright © 2017 Vergil. All rights reserved.
//

import RxSwift
import RxCocoa
import RealmSwift
import RxDataSources
import Action

typealias CountrySection = AnimatableSectionModel<String, Country>

struct CountryListViewModel {
  
  let service: CountryServiceType
  
  init(service: CountryServiceType) {
    self.service = service
  }
  
  var sectionedCountries: Driver<[CountrySection]> {
    return service.allObjects()
      .map { [CountrySection(model: "", items: $0)] }
      .asDriver(onErrorJustReturn: [])
  }
  
  @discardableResult
  func createCountry(name: String, acronym: String) -> Observable<Country> {
    let country = Country()
    country.name = name
    country.acronym = acronym
    return service.create(object: country)
  }
  
  var addAction: CocoaAction {
    return CocoaAction { _ in
      return self.createCountry(name: "Dafuq", acronym: "DAF")
        .map { _ in }
    }
  }
  
  lazy var deleteAction: Action<Country, Void> = {
    selfCopy -> Action<Country, Void> in
    
    return Action<Country, Void> { country in
      selfCopy.service.delete(object: country)
      return Observable<Void>.empty()
    }
  }(self)
}
