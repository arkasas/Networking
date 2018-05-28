//
//  JSONParameterEncoder.swift
//  Networking
//
//  Created by Arkadiusz Pituła on 10.04.2018.
//  Copyright © 2018 Arkadiusz Pituła. All rights reserved.
//

import Foundation

class JSONParameterEncoder: ParameterEncoder {

    func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        do {
            let json = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            urlRequest.httpBody = json

            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        } catch {
            throw ParametersError.encodingFailed
        }
    }
}
