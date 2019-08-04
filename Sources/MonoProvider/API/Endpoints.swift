//
//  Endpoints.swift
//  MonoProvider
//
//  Created by Alexander Kravchenko on 03.08.2019.
//

import Foundation

private let baseURL = "https://api.monobank.ua"

enum MonoEndpoint {
    // Public
    case currency

    //Personal
    case personalInfo
    case statement(account: String, from: String, to: String?)
    case createWebhook

    var endpoint: String {
        switch self {
        case .currency: return baseURL + "/bank/currency"
        case .personalInfo: return baseURL + "/personal/client-info"
        case .statement(let account, let fromDate, let toDate):
            var url = baseURL + "/personal/statement/\(account)/\(fromDate)/"
            if let toDate = toDate { url += toDate }
            return url
        case .createWebhook: return baseURL + "/personal/webhook"
        }
    }
}
