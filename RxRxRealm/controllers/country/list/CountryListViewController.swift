//
//  CountryListViewController.swift
//  RxRxRealm
//
//  Created by André Marques da Silva Rodrigues on 22/12/17.
//  Copyright © 2017 Vergil. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Action
import RealmSwift

class CountryListViewController: UIViewController {
  
  var viewModel = CountryListViewModel(service: CountryService(realmProvider: DefaultRealmProvider()))
  let bag = DisposeBag()
  
  var dataSource: RxTableViewSectionedAnimatedDataSource<CountrySection>!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var addButton: UIBarButtonItem!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configDataSource()
    bindUI()
    
//    let json = try! Data.init(contentsOf: URL.init(string: "http://localhost:3000/api/country/lNPiQNZgEb")!)
//    
//    let countryCR = try!  ModelObjectJSON.decoder.decode(Country.CodableRepresentation.self, from: json)
//    
//    let country = try! Country(codableRepresentation: countryCR)
//    
//    viewModel.service.create(object: country)
  }
  
  func bindUI() {
    
    viewModel.sectionedCountries
      .drive(tableView.rx.items(dataSource: dataSource))
      .disposed(by: bag)
    
    addButton.rx.action = viewModel.addAction
    
    tableView.rx.modelDeleted(Country.self)
      .bind(to: viewModel.deleteAction.inputs)
      .disposed(by: bag)
    
    tableView.rx.itemSelected
      .do(onNext: {
        self.tableView.deselectRow(at: $0, animated: true)
      })
      .subscribe()
      .disposed(by: bag)
    
    
    tableView.rx.modelSelected(Country.self)
      .subscribe(onNext: { country in
        self.performSegue(withIdentifier: "toDetail", sender: country)
      })
      .disposed(by: bag)
  }
  
  func configDataSource() {
    
    dataSource = RxTableViewSectionedAnimatedDataSource<CountrySection>(configureCell: { (_, tableView, indexPath, model) -> UITableViewCell in
      
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
        return UITableViewCell()
      }
      
      cell.textLabel?.text = model.name
      
      return cell
    })
    
    dataSource.canEditRowAtIndexPath = { _, _ in true }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if segue.identifier == "toDetail",
      let country = sender as? Country {
      
      let vc = segue.destination as! CountryDetailViewController
      vc.viewModel = CountryDetailViewModel(country: country, countryService: viewModel.service, cityService: CityService())
    }
  }
}

