//
//  PublicAPITests.swift
//  MonoProviderTests
//
//  Created by Alexander Kravchenko on 04.08.2019.
//

import XCTest
@testable import Vapor
@testable import MonoProvider

class PublicAPITests: XCTestCase {
    private let currenciesJSONString = """
    [
        {"currencyCodeA":840,"currencyCodeB":980,"date":1564882805,"rateBuy":25.411,"rateSell":25.7619},
        {"currencyCodeA":978,"currencyCodeB":980,"date":1564882805,"rateBuy":27.961,"rateSell":28.5608},
        {"currencyCodeA":643,"currencyCodeB":980,"date":1564882805,"rateBuy":0.36,"rateSell":0.4},
        {"currencyCodeA":978,"currencyCodeB":840,"date":1564882805,"rateBuy":1.1004,"rateSell":1.1169},
        {"currencyCodeA":826,"currencyCodeB":980,"date":1564910345,"rateCross":31.2489},
        {"currencyCodeA":756,"currencyCodeB":980,"date":1564910314,"rateCross":26.0886},
        {"currencyCodeA":933,"currencyCodeB":980,"date":1564910665,"rateCross":12.567},
        {"currencyCodeA":124,"currencyCodeB":980,"date":1564910503,"rateCross":19.45},
        {"currencyCodeA":203,"currencyCodeB":980,"date":1564910666,"rateCross":1.1089},
        {"currencyCodeA":208,"currencyCodeB":980,"date":1564908157,"rateCross":3.8263},
        {"currencyCodeA":348,"currencyCodeB":980,"date":1564910636,"rateCross":0.0873},
        {"currencyCodeA":985,"currencyCodeB":980,"date":1564910673,"rateCross":6.6402},
        {"currencyCodeA":949,"currencyCodeB":980,"date":1564910641,"rateCross":4.6102}
    ]
"""
    
    func testCurrenciesParsedProperly() throws {
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            
            let body = HTTPBody(string: currenciesJSONString)
            var headers: HTTPHeaders = [:]
            headers.replaceOrAdd(name: .contentType, value: MediaType.json.description)
            let request = HTTPRequest(headers: headers, body: body)
            
            let currenciesFuture = try JSONDecoder().decode(CurrencyInfoResponse.self, from: request, maxSize: 65_536, on: EmbeddedEventLoop())
            
            _ = currenciesFuture.do { response in
                XCTAssertEqual(response.currencies.count, 13)
                
                let currency = response.currencies.first!
                XCTAssertEqual(currency.currencyCodeA, 840)
                XCTAssertEqual(currency.currencyCodeB, 980)
                XCTAssertEqual(currency.date, 1564882805)
                XCTAssertEqual(currency.rateBuy, 25.411)
                XCTAssertEqual(currency.rateSell, 25.7619)
                XCTAssertNil(currency.rateCross)
            }
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
