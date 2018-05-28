//
//  URLParameterEncoder.swift
//  Networking
//
//  Created by Arkadiusz Pituła on 10.04.2018.
//  Copyright © 2018 Arkadiusz Pituła. All rights reserved.
//

import Foundation

class URLParameterEncoder: ParameterEncoder {

    func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        guard let url = urlRequest.url else {
            throw ParametersError.missingURL
        }

        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            composeComponents(component: &urlComponents, paramters: parameters)
            urlRequest.url = urlComponents.url
        }

        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
    }

    private func composeComponents(component: inout URLComponents, paramters: Parameters) {
        component.queryItems = [URLQueryItem]()

        for (key, value) in paramters {
            let queryItem = URLQueryItem(name: key, value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
            component.queryItems?.append(queryItem)
        }
    }

}
