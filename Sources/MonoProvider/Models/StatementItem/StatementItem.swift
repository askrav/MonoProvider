//
//  StatementItem.swift
//  MonoProvider
//
//  Created by Alexander Kravchenko on 03.08.2019.
//

import Foundation

public struct StatementItem: MonoModel {
    let id: String
    let time: Int
    let description: String
    let mcc: Int
    let hold: Bool
    let amount: Int
    let operationAmount: Int
    let currencyCode: Int
    let commissionRate: Int
    let cashbackAmount: Int
    let balance: Int
}

public struct StatementItems: MonoModel {
    let items: [StatementItem]

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        items = try container.decode([StatementItem].self)
    }
}
