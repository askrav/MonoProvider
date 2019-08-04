//
//  PersonalAPITests.swift
//  MonoProviderTests
//
//  Created by Alexander Kravchenko on 04.08.2019.
//

import XCTest
@testable import Vapor
@testable import MonoProvider

class PersonalAPITests: XCTestCase {
    private let userInfoJSONString = """
    {
        "name": "John",
        "webHookUrl": "http://google.com",
        "accounts": [
            {
            "id": "kKGVoZuHWzqVoZuH",
            "balance": 10000000,
            "creditLimit": 10000000,
            "currencyCode": 980,
            "cashbackType": "UAH"
            }
        ]
    }
"""
    
    private let statementJSONString = """
    [
      {
        "id": "ZuHWzqkKGVo=",
        "time": 1554466347,
        "description": "Grocery store",
        "mcc": 7997,
        "hold": false,
        "amount": -95000,
        "operationAmount": -95000,
        "currencyCode": 980,
        "commissionRate": 0,
        "cashbackAmount": 19000,
        "balance": 10050000
      }
    ]
"""
    func testUserInfoParsedProperly() throws {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        let body = HTTPBody(string: userInfoJSONString)
        var headers: HTTPHeaders = [:]
        headers.replaceOrAdd(name: .contentType, value: MediaType.json.description)
        let request = HTTPRequest(headers: headers, body: body)
        
        let userInfoFuture = try JSONDecoder().decode(UserInfo.self, from: request, maxSize: 65_536, on: EmbeddedEventLoop())
        
        _ = userInfoFuture.do { userInfo in
            XCTAssertEqual(userInfo.name, "John")
            XCTAssertEqual(userInfo.webHookUrl, #"http://google.com"#)
            
            let account = userInfo.accounts.first!
            XCTAssertEqual(account.id, "kKGVoZuHWzqVoZuH")
            XCTAssertEqual(account.balance, 10000000)
            XCTAssertEqual(account.creditLimit, 10000000)
            XCTAssertEqual(account.currencyCode, 980)
            XCTAssertEqual(account.cashbackType, .UAH)
        }
    }
    
    func testStatementParsedProperly() throws {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        let body = HTTPBody(string: statementJSONString)
        var headers: HTTPHeaders = [:]
        headers.replaceOrAdd(name: .contentType, value: MediaType.json.description)
        let request = HTTPRequest(headers: headers, body: body)
        
        let statementsFuture = try JSONDecoder().decode(StatementItems.self, from: request, maxSize: 65_536, on: EmbeddedEventLoop())
        
        _ = statementsFuture.do { data in
            XCTAssertEqual(data.items.count, 1)
            
            let item = data.items.first!
            XCTAssertEqual(item.id, "ZuHWzqkKGVo=")
            XCTAssertEqual(item.time, 1554466347)
            XCTAssertEqual(item.description, "Grocery store")
            XCTAssertEqual(item.mcc, 7997)
            XCTAssertEqual(item.hold, false)
            XCTAssertEqual(item.amount, -95000)
            XCTAssertEqual(item.operationAmount, -95000)
            XCTAssertEqual(item.currencyCode, 980)
            XCTAssertEqual(item.commissionRate, 0)
            XCTAssertEqual(item.cashbackAmount, 19000)
            XCTAssertEqual(item.balance, 10050000)
        }
    }
}
