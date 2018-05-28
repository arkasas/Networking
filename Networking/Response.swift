//
//  Response.swift
//  Networking
//
//  Created by Arkadiusz Pituła on 10.04.2018.
//  Copyright © 2018 Arkadiusz Pituła. All rights reserved.
//

import Foundation

public struct ServerError: Decodable {
    let code: Int?
    let message: String?

    static var empty = ServerError(code: 0, message: "")
}

public enum Result<T: Decodable> {
    case success(value: T)
    case fail(error: ServerError)
}

public struct Response<Value: Decodable> {
    let urlResponse: URLResponse?

    public var httpUrlResponse: HTTPURLResponse? {
        return (urlResponse as? HTTPURLResponse)
    }
    
    let error: Error?
    let data: Data?

    public var statusCode: Int {
        if let res = httpUrlResponse {
            return res.statusCode
        }
        return 0
    }

    public var serverError: ServerError? {
        switch statusCode {
        case 200...299:
            return nil
        default:
            guard let data = data else {
                return nil
            }

            return parseError(data: data)
        }
    }

    public var result: Result<Value> {
        switch statusCode {
        case 200...299:
            if let value = value {
                return Result.success(value: value)
            }
            return Result.fail(error: ServerError(code: 0, message: "Cannot convert"))
        default:
            return Result.fail(error: serverError ?? ServerError.empty)
        }
    }


    public var value: Value? {
        guard let data = data else {
            return nil
        }
        return parse(data: data)
    }

    init(data: Data?, urlResponse: URLResponse?, error: Error?) {
        self.data = data
        self.urlResponse = urlResponse
        self.error = error
    }

    private func parse(data: Data) -> Value? {
        do {
            let val = try JSONDecoder().decode(Value.self, from: data)
            return val
        } catch {
            print(error)
            return nil
        }
    }

    private func parseError(data: Data) -> ServerError? {
        do {
            let val = try JSONDecoder().decode(ServerError.self, from: data)
            return val
        } catch {
            return nil
        }
    }
}
