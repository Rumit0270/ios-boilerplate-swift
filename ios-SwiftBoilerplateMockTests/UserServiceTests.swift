//
//  UserServiceTests.swift
//  ios-SwiftBoilerplateMockTests
//
//  Created by Mac on 2/8/20.
//

import Foundation
import XCTest
import RealmSwift
@testable import ios_SwiftBoilerplate

class UserServiceTests: XCTestCase {
    
    var sut: UserService!
    
    override func setUp() {
        super.setUp()
        sut = UserService(mock: true)
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testUsersDataAreCorrectlyStoredAfterFetching() {
        let promise = expectation(description: "User Data are correctly stored after fetching from API.")
        
        sut.fetchUsers(success: {
            RealmHelper.fetchObjects(onSuccess: { (results: Results<UserObject>) in
                guard results.count > 0 else {
                    XCTFail("No data stored in realm")
                    return
                }
                XCTAssertEqual(results.count, 2)
                promise.fulfill()
            }, onFailure: { (_) in
                XCTFail("Error fetching data from Local DB.")
            })
        }, failure: { (_) in
            XCTFail("Error fetching data from the API.")
        })
        
        wait(for: [promise], timeout: 3)
    }

}
