//
//  Request.swift
//  Networking
//
//  Created by Arkadiusz Pituła on 10.04.2018.
//  Copyright © 2018 Arkadiusz Pituła. All rights reserved.
//

import Foundation

public protocol Request {
    var endPoint: String { get set }
    var method: HTTPMethod { get set }

    var urlParameters: Parameters? { get }
    var bodyParameters: Parameters? { get }
    var additionalHeader: HTTPHeader? { get }

    func build(baseApi: String, baseRouter: String) throws -> URLRequest
}

public extension Request {
    func build(baseApi: String, baseRouter: String) throws -> URLRequest {
        var request = URLRequest(url: buildURL(baseApi: baseApi, baseRouter: baseRouter), cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 60.0)
        request.httpMethod = method.rawValue

        do {
            try configureParameters(request: &request)
            addHeaderIfNeeded(request: &request)
            return request
        } catch {
            throw error
        }
    }

    private func buildURL(baseApi: String, baseRouter: String) -> URL {
        return URL(string: baseApi + baseRouter + endPoint)!
    }

    private func configureParameters(request: inout URLRequest) throws {
        do {
            if let url = urlParameters {
                try URLParameterEncoder().encode(urlRequest: &request, with: url)
            }

            if let body = bodyParameters {
                try JSONParameterEncoder().encode(urlRequest: &request, with: body)
            }
        } catch {
            throw error
        }
    }

    private func addHeaderIfNeeded(request: inout URLRequest) {
        guard let headers = additionalHeader else { return }

        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }

}

