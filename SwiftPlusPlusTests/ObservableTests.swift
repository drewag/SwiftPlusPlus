//
//  ObservableTests.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 7/27/14.
//  Copyright (c) 2014 Drewag LLC. All rights reserved.
//

import UIKit
import XCTest

class ObservableTests: XCTestCase {
    func testSubscribing() {
        var observable = Observable<String>("Old Value")
        var called = false
        observable.addObserver(self) {
            (change) in
            XCTAssertEqual((change as! UpdateValue<String>).oldValue, "Old Value")
            XCTAssertEqual(change.newValue, "New Value")
            called = true
        }
        observable.value = "New Value"
        XCTAssertTrue(called)
    }

    func testUnsubscribing() {
        var observable = Observable<String>("Old Value")
        var called = false
        observable.addObserver(self) {
            (change) in
            called = true
        }
        observable.removeObserver(self)
        observable.value = "New Value"
        XCTAssertFalse(called)
    }

    func testTriggerImmediately() {
        var observable = Observable<String>("Current Value")
        var called = false
        observable.addObserver(self, options: ObservationOptions.Initial) {
            (change) in
            XCTAssertNil(change as? UpdateValue<String>)
            XCTAssertEqual(change.newValue, "Current Value")
            called = true
        }
        XCTAssertTrue(called)
    }

    func testAutomaticUnsubscribing() {
        class SomeClass {
        }
        var observable = Observable<String>("Current Value")
        var called = false
        func scope() {
            var observer = SomeClass()
            observable.addObserver(observer) {
                (change) in
                called = true
            }
        }
        scope()
        observable.value = "New Value"
        XCTAssertFalse(called)
    }
    
    func testCallOnceOption() {
        var observable = Observable<String>("Current Value")
        var called = false
        observable.addObserver(self, options: ObservationOptions.OnlyOnce) {
            (change) in
            XCTAssertEqual(change.newValue, "Second Value")
            called = true
        }
        XCTAssertFalse(called)
        
        observable.value = "Second Value"
        XCTAssertTrue(called)
        
        called = false
        observable.value = "Third Value"
        XCTAssertFalse(called)
    }
    
    func testCallOnceOptionWithInitial() {
        var observable = Observable<String>("Current Value")
        var called = false
        observable.addObserver(self, options: ObservationOptions.Initial | ObservationOptions.OnlyOnce) {
            (change) in
            called = true
        }
        XCTAssertTrue(called)
        
        observable.value = "Second Value"
        XCTAssertTrue(called)
        
        called = false
        observable.value = "Third Value"
        XCTAssertFalse(called)
    }
}
