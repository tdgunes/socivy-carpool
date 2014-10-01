//
//  SocivyAPITests.swift
//  OzU Carpool
//
//  Created by Taha Doğan Güneş on 01/10/14.
//  Copyright (c) 2014 TDG. All rights reserved.
//

import UIKit
import XCTest


class SocivyAPILoginTests: XCTestCase, SocivyAPILoginDelegate {
    
    var api:SocivyAPI?
    
    override func setUp() {
        super.setUp()


        api = SocivyAPI()
        api?.loginAPI?.delegate = self
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
        api?.loginAPI?.authenticate("kalaomer@hotmail.com", password: "123123")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.

        }
    }
    
    func loginDidFinish(socivyAPI: SocivyLoginAPI) {

    }

    func loginDidFailWithError(socivyAPI: SocivyLoginAPI, error: NSError) {
        

    }
}
