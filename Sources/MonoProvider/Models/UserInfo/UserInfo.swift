//
//  UserInfo.swift
//  Async
//
//  Created by Alexander Kravchenko on 03.08.2019.
//

import Foundation

public struct UserInfo: MonoModel {
    public let name: String
    public let webHookUrl: String?
    public let accounts: [UserInfoAccount]
}

public struct UserInfoAccount: MonoModel {
    public let id: String
    public let balance: Int
    public let creditLimit: Int
    public let currencyCode: Int
    public let cashbackType: CashBackType
}

public enum CashBackType: String, MonoModel {
    case None
    case UAH
    case Miles
}
