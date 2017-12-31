//
//  ModelObjectServiceTest.swift
//  RxRxRealmTests
//
//  Created by André Marques da Silva Rodrigues on 28/12/17.
//  Copyright © 2017 Vergil. All rights reserved.
//

import XCTest
import RxBlocking

@testable import RxSwift
@testable import RealmSwift
@testable import RxRealm
@testable import RxRxRealm

class ModelObjectServiceTest: XCTestCase {

  var service: ModelObjectService<ModelObject>!
  var disposeBag = DisposeBag()
  
  override func setUp() {
    super.setUp()
    
    service = ModelObjectService(realmProvider: TestRealmProvider())
    
  }
  
  override func tearDown() {
    disposeBag = DisposeBag()
    super.tearDown()
  }
  
  func testCreate() {
    
    let object = ModelObject()
    
    XCTAssertNil(object.uid)
    
    _ = service.create(object: object).toBlocking().materialize()
    
    XCTAssertNotNil(object.uid, "created object exists")
  }
  
  func testCreate_keepProperties() {
    
    let props: (String, Date, Date, Date?) = ("some uid", Date.distantPast, Date(), nil)
    
    let object = ModelObject()
    object.uid = props.0
    object.createdAt = props.1
    object.updatedAt = props.2
    object.deletedAt = props.3
    
    _ = service.create(object: object).toBlocking().materialize()
    
    XCTAssertEqual(object.uid,
                   props.0,
                   "object keeps its original uid")
    XCTAssertEqual(object.createdAt,
                   props.1,
                   "object keeps its original uid")
    XCTAssertEqual(object.updatedAt,
                   props.2,
                   "object keeps its original uid")
    XCTAssertEqual(object.deletedAt,
                   props.3,
                   "object keeps its original uid")
  }
  
  func testDelete() {
    
    let object = ModelObject()
    
    service.create(object: object)
    
    XCTAssertNil(object.deletedAt,
                 "brand new object should not have deletedAt set")
    
    _ = service.delete(object: object).toBlocking().materialize()
    
    XCTAssertNotNil(object.deletedAt,
                    "object should have deletedAt since it was just deleted")
  }
  
  func testGetAll() {
    
    let objects = (0..<5).map { _ in ModelObject() }
    
    objects.forEach {
      _ = self.service.create(object: $0).toBlocking().materialize()
    }
    
    guard case let retrievedObjects?? = try? service
      .allObjects(getDeleted: false)
      .toBlocking(timeout: 1).first()?.toArray() else {
        XCTFail("retrieving objects failed")
        return
    }
    
    XCTAssertEqual(objects, retrievedObjects, "created objects are being retrieved")
  }
  
  func testGetAll_getDeleted() {
    
    let objects = (0..<3).map { _ in ModelObject() }
    
    objects.forEach {
      _ = self.service.create(object: $0).toBlocking().materialize()
    }
    
    _ = service.delete(object: objects[0]).toBlocking().materialize()
    _ = service.delete(object: objects[1]).toBlocking().materialize()
    
    guard case let retrievedNonDeletedObjects?? = try? service
      .allObjects(getDeleted: false)
      .toBlocking(timeout: 1).first()?.toArray() else {
        XCTFail("retrieving objects failed")
        return
    }
    
    XCTAssertFalse(retrievedNonDeletedObjects.contains(objects[0]),
                   "retrieved objects cannot contain deleted objects")
    XCTAssertFalse(retrievedNonDeletedObjects.contains(objects[1]),
                   "retrieved objects cannot contain deleted objects")
    XCTAssert(retrievedNonDeletedObjects.contains(objects[2]),
              "retrieved objects must contain non-deleted objects")
    
    guard case let retrievedObjects?? = try? service
      .allObjects(getDeleted: true)
      .toBlocking(timeout: 1).first()?.toArray() else {
        XCTFail("retrieving objects failed")
        return
    }
    
    XCTAssert(retrievedObjects.contains(objects[0]),
              "retrieved objects must contain deleted objects")
    XCTAssert(retrievedObjects.contains(objects[1]),
              "retrieved objects must contain deleted objects")
    XCTAssert(retrievedObjects.contains(objects[2]),
              "retrieved objects must contain non-deleted objects")
    XCTAssertEqual(retrievedObjects, objects)
  }
  
  func testGetAll_filterClosure() {
    
    let pastRange = 0..<3
    
    let objects = (0..<5).map { i -> ModelObject in
      let object = ModelObject()
      
      if pastRange ~= i {
        object.createdAt = Date.distantPast
      } else {
        object.createdAt = Date.distantFuture
      }
      return object
    }
    
    objects.forEach {
      _ = self.service.create(object: $0).toBlocking().materialize()
    }
    
    let filterPast: (Results<ModelObject>) -> Results<ModelObject> = {
      (results) -> (Results<ModelObject>) in
      results.filter("createdAt < %@", Date())
    }
    
    guard case let pastObjects?? = try? service
      .allObjects(getDeleted: false,
                  filterClosure: filterPast)
      .toBlocking(timeout: 1).first()?.toArray() else {
        XCTFail("retrieving objects failed")
        return
    }
    
    XCTAssertEqual(pastObjects,
                   Array(objects[pastRange]),
                   "filtered out the future objects")
    
    let filterFuture: (Results<ModelObject>) -> Results<ModelObject> = {
      (results) -> (Results<ModelObject>) in
      results.filter("createdAt > %@", Date())
    }
    
    guard case let futureObjects?? = try? service
      .allObjects(getDeleted: false,
                  filterClosure: filterFuture)
      .toBlocking(timeout: 1).first()?.toArray() else {
        XCTFail("retrieving objects failed")
        return
    }
    
    XCTAssertEqual(futureObjects,
                   Array(objects[3..<5]),
                   "filtered out the past objects") 
  }
  
  func testGetById() {
    
    let object = ModelObject()
    
    let uid = "some uid"
    object.uid = uid
    
    _ = service.create(object: object).toBlocking().materialize()
    
    guard case let foundObject?? = try? service.object(withUid: uid)
      .toBlocking().first() else {
        XCTFail("retrieving objects failed")
        return
    }
    
    XCTAssertEqual(object, foundObject)
  }
  
  func testUpdate() {
    
    let object = ModelObject()
    
    _ = service.create(object: object).toBlocking().materialize()
    
    let now = Date.distantPast
    
    _ = service.update(object: object) {
      object.createdAt = now
    }
      .toBlocking().materialize()
    
    XCTAssertEqual(now, object.createdAt)
  }
}
