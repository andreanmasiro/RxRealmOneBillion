//
//  CountryDetailViewModel.swift
//  RxRxRealm
//
//  Created by André Marques da Silva Rodrigues on 23/12/17.
//  Copyright © 2017 Vergil. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources
import RealmSwift
import RxRealm
import Action

typealias CitySection = AnimatableSectionModel<String, City>

struct CountryDetailViewModel {
  
  var country: Country
  var countryService: CountryServiceType
  var cityService: CityServiceType
  
  var sectionedCities: Driver<[CitySection]> {
    return cityService.allObjects(country: country)
      .map { [CitySection(model: "", items: $0)] }
      .asDriver(onErrorJustReturn: [])
  }
  
  init(country: Country,
       countryService: CountryServiceType,
       cityService: CityServiceType) {
    self.country = country
    self.countryService = countryService
    self.cityService = cityService
  }
  
  lazy var editAction: Action<(String, String), Void> = { selfCopy in
    
    return Action<(String, String), Void> {
      (countryData) in
      
      let (name, acronym) = countryData
      return selfCopy.countryService.update(object: selfCopy.country) {
        selfCopy.country.name = name
        selfCopy.country.acronym = acronym
      }
        .map { _ in }
    }
  }(self)
  
  lazy var createCityAction: Action<String, City> = { selfCopy in
    
    return Action<String, City> { name -> Observable<City> in
      
      let city = City()
      city.name = name
      city.country = selfCopy.country
      
      return selfCopy.cityService.create(object: city)
    }
  }(self)
  
  lazy var deleteCityAction: Action<City, Void> = { selfCopy in
    
    return Action<City, Void> { city -> Observable<Void> in
      
      selfCopy.cityService.delete(object: city)
      return Observable<Void>.empty()
    }
  }(self)
}
