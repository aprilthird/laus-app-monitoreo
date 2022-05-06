//
//  RestAPI.swift
//  TempoMonitoring
//
//  Created by Jose Silva on 30/08/21.
//  Copyright © 2021 Sportafolio SAC. All rights reserved.
//

import Foundation
import Alamofire

enum ResponseAPI<T> {
    case success(T)
    case failure(Error)
}

protocol RestAPI {
    
    func callService<T>(urlString: String,
                        verb: HTTPMethod,
                        body: [String: Any]?,
                        headers: [String: String]?,
                        completion: @escaping (ResponseAPI<T>) -> Void) where T: Decodable
}

extension RestAPI {
    
    func callService<T:Decodable>(urlString: String,
                                  verb: HTTPMethod,
                                  body: [String: Any]? = nil,
                                  headers: [String: String]? = nil,
                                  completion: @escaping (ResponseAPI<T>) -> Void) {
        
        var httpHeaders: HTTPHeaders?
        if let myHeaders = headers {
            httpHeaders = HTTPHeaders(myHeaders)
        }
        
        let afRequest = AF.request(urlString,
                                   method: verb,
                                   parameters: body,
                                   encoding: JSONEncoding.default,
                                   headers: httpHeaders)
        afRequest.validate().responseDecodable(of: T.self) { (response) in
            switch response.result {
            case .success(let dto):
                completion(.success(dto))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

public enum NetworkError: String, Error {
    case internetFailure = "Nos quedamos sin internet! Asegúrese de estar conectado a una red de internet."
}
