//
//  Router.swift
//  Networking
//
//  Created by Arkadiusz Pituła on 10.04.2018.
//  Copyright © 2018 Arkadiusz Pituła. All rights reserved.
//

import Foundation

open class Router {
    open var api: API!
    open var path: String = "/"
    private var request: Request?
    private var task: URLSessionTask?

    public init() {}

    public init(request: Request) {
        self.request = request
    }

    public func execute<T: Decodable>(completionHandler: @escaping (Response<T>) -> Void) {
        guard let request = request else {
            completionHandler(Response(data: nil, urlResponse: nil, error: nil))
            return
        }

        executeRequest(request: request, completionHandler: completionHandler)
    }

    public func execute<T: Decodable>(request: Request, completionHandler: @escaping (Response<T>) -> Void) {
        executeRequest(request: request, completionHandler: completionHandler)
    }

    private func executeRequest<T: Decodable>(request: Request, completionHandler: @escaping (Response<T>) -> Void) {
        let session = URLSession.shared

        do {
            let urlRequest = try request.build(baseApi: api.baseURL, baseRouter: path)
            task = session.dataTask(with: urlRequest, completionHandler: { data, response, error in
                completionHandler(Response(data: data, urlResponse: response, error: error))
            })
        } catch {
            completionHandler(Response(data: nil, urlResponse: nil, error: error))
        }

        task?.resume()
    }

    public func cancel() {
        task?.cancel()
    }
}
