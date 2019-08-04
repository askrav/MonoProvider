//
//  CurrencyInfo.swift
//  MonoProvider
//
//  Created by Alexander Kravchenko on 03.08.2019.
//

import Foundation

public struct CurrencyInfo: MonoModel {
    public var currencyCodeA: Int
    public var currencyCodeB: Int
    public var date: Int
    public var rateSell: Double?
    public var rateBuy: Double?
    public var rateCross: Double?
}

public struct CurrencyInfoResponse: MonoModel {
    let currencies: [CurrencyInfo]

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        currencies = try container.decode([CurrencyInfo].self)
    }
}

