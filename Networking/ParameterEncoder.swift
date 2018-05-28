//
//  ParameterEncoder.swift
//  Networking
//
//  Created by Arkadiusz Pituła on 10.04.2018.
//  Copyright © 2018 Arkadiusz Pituła. All rights reserved.
//

import Foundation

public typealias Parameters = [String: Any]

public enum ParametersError: String, Error {
    case parametersNil = "Parameters were nil."
    case encodingFailed = "Parameter encoding failed."
    case missingURL = "URL is nil."

}

protocol ParameterEncoder {
    func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}

enum ParameterEncoding {
    case urlEncoding
    case jsonEncoding
    case urlAndJsonEncoding

    func encode(urlRequest: inout URLRequest, bodyParameters: Parameters?, urlParameters: Parameters?) throws {
        do {
            switch self {
            case .urlEncoding:
                try urlEncode(urlParameters: urlParameters, urlRequest: &urlRequest)
            case .jsonEncoding:
                try jsonEncode(bodyParameters: bodyParameters, urlRequest: &urlRequest)
            case .urlAndJsonEncoding:
                try urlJsonEncode(urlParameters: urlParameters, bodyParameters: bodyParameters, urlRequest: &urlRequest)
            }
        } catch {
            throw error
        }
    }

    private func urlEncode(urlParameters: Parameters?, urlRequest: inout URLRequest) throws {
        guard let params = urlParameters else { return }
        try URLParameterEncoder().encode(urlRequest: &urlRequest, with: params)
    }

    private func jsonEncode(bodyParameters: Parameters?, urlRequest: inout URLRequest) throws {
        guard let params = bodyParameters else { return }
        try JSONParameterEncoder().encode(urlRequest: &urlRequest, with: params)
    }

    private func urlJsonEncode(urlParameters: Parameters?, bodyParameters: Parameters?, urlRequest: inout URLRequest) throws {
        guard let urlParams = urlParameters, let bodyParams = bodyParameters else { return }
        try URLParameterEncoder().encode(urlRequest: &urlRequest, with: urlParams)
        try JSONParameterEncoder().encode(urlRequest: &urlRequest, with: bodyParams)
    }
}
