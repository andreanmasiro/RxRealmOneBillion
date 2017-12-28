//
//  CountryDetailViewController.swift
//  RxRxRealm
//
//  Created by André Marques da Silva Rodrigues on 23/12/17.
//  Copyright © 2017 Vergil. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class CountryDetailViewController: UIViewController {
  
  var viewModel: CountryDetailViewModel!
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var acronymTextField: UITextField!
  
  var doneButton: UIBarButtonItem!
  var addButton: UIBarButtonItem!
  
  var dataSource: RxTableViewSectionedAnimatedDataSource<CitySection>!
  
  var bag = DisposeBag()
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    nameTextField.text = viewModel.country.name
    acronymTextField.text = viewModel.country.acronym
    
    addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showCityAlert))
    
    doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
    
    navigationItem.rightBarButtonItem = addButton
    
    bindUI()
  }
  
  func bindUI() {
    
    bindLeftButtonItem()
    bindTableView()
  }
  
  func bindTableView() {
    
    configDataSource()
    
    viewModel.sectionedCities
      .drive(tableView.rx.items(dataSource: dataSource))
      .disposed(by: bag)
    
    tableView.rx.modelDeleted(City.self)
      .bind(to: viewModel.deleteCityAction.inputs)
      .disposed(by: bag)
  }
  
  func bindLeftButtonItem() {
    
    let didEditName = nameTextField.rx
      .controlEvent(UIControlEvents.editingDidEnd)
      .asObservable()
    
    let didEditAcronym = acronymTextField.rx
      .controlEvent(UIControlEvents.editingDidEnd)
      .asObservable()
    
    let didBeginEdittingName = nameTextField.rx
      .controlEvent(UIControlEvents.editingDidBegin)
      .asObservable()
    
    let didBeginEdittingAcronym = acronymTextField.rx
      .controlEvent(UIControlEvents.editingDidBegin)
      .asObservable()
    
    Observable.merge(didBeginEdittingName, didBeginEdittingAcronym)
      .do(onNext: {
        self.navigationItem.leftBarButtonItem = self.doneButton
      })
      .subscribe()
      .disposed(by: bag)
    
    Observable.merge(didEditName, didEditAcronym)
      .do(onNext: {
        self.navigationItem.leftBarButtonItem = nil
      })
      .subscribe(onNext: {
        let name = self.nameTextField.text ?? ""
        let acronym = self.acronymTextField.text ?? ""
        self.viewModel.editAction.execute((name, acronym))
      })
      .disposed(by: bag)
  }
  
  @objc func done() {
    
    nameTextField.resignFirstResponder()
    acronymTextField.resignFirstResponder()
  }
  
  @objc func showCityAlert() {
    
    let alert = UIAlertController(title: "New City", message: "", preferredStyle: .alert)
    
    var textObservable: Observable<String>!
    let tapObserver = PublishSubject<Void>()
    
    alert.addTextField { (textField) in
      
      textField.placeholder = "Name"
      textObservable = textField.rx.text
        .flatMap { Observable.from(optional: $0) }
    }
    
    alert.addAction(
        UIAlertAction(
        title: "Save",
        style: .default,
        handler: { (action) in
          tapObserver.onNext(())
        }
      )
    )
    
    alert.addAction(
      UIAlertAction(
        title: "Cancel",
        style: .cancel,
        handler: { _ in }
      )
    )
    
    tapObserver.withLatestFrom(textObservable)
      .bind(to: viewModel.createCityAction.inputs)
      .disposed(by: bag)
    
    present(alert, animated: true)
  }
  
  func configDataSource() {
    
    dataSource = RxTableViewSectionedAnimatedDataSource<CitySection>(configureCell: { (_, tableView, indexPath, model) -> UITableViewCell in
      
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
        return UITableViewCell()
      }
      
      cell.textLabel?.text = model.name
      
      return cell
    })
    
    dataSource.canEditRowAtIndexPath = { _, _ in true }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}
