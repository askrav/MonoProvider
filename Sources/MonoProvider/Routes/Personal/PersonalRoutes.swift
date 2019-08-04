//
//  PersonalRoutes.swift
//  Async
//
//  Created by Alexander Kravchenko on 03.08.2019.
//

import Vapor

public protocol PersonalRoutes {
    func userInfo() throws -> Future<UserInfo>
    func statement(account: String, from: String, to: String?) throws -> Future<StatementItems>
    func createWebHook(url: String) throws -> Future<EmptyModel>
}

public struct MonoPersonalRoutes: PersonalRoutes {
    private let request: MonoPublicAPIRequest
    
    init(request: MonoPersonalAPIRequest) {
        self.request = request
    }

    public func userInfo() throws -> EventLoopFuture<UserInfo> {
        return try request.send(method: .GET, path: MonoEndpoint.personalInfo.endpoint)
    }

    public func statement(account: String, from: String, to: String? = nil) throws -> Future<StatementItems> {
        return try request.send(method: .GET,
                                path: MonoEndpoint.statement(account: account, from: from, to: to).endpoint)
    }
    
    public func createWebHook(url: String) throws -> EventLoopFuture<EmptyModel> {
        let parameters: [String: Any] = [
            "webHookUrl": url
        ]
        let data = try JSONSerialization.data(withJSONObject: parameters)
        let body = HTTPBody(data: data)
        return try request.send(method: .POST, path: MonoEndpoint.createWebhook.endpoint, body: body)
    }
}
