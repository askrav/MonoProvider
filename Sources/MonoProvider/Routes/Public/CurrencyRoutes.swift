//
//  CurrencyRoutes.swift
//  MonoProvider
//
//  Created by Alexander Kravchenko on 03.08.2019.
//

import Vapor

public protocol CurrencyRoutes {
    func getCurrencies() throws -> Future<CurrencyInfoResponse>
}

public struct MonoCurrencyRoutes: CurrencyRoutes {
    private let request: MonoPublicAPIRequest
    
    init(request: MonoPublicAPIRequest) {
        self.request = request
    }

    public func getCurrencies() throws -> EventLoopFuture<CurrencyInfoResponse> {
        return try request.send(method: .GET, path: MonoEndpoint.currency.endpoint)
    }
}
