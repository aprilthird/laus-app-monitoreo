//
//  ResponseHelper.swift
//  TempoMonitoring
//
//  Created by Hugo Andres Rosado on 5/30/20.
//  Copyright © 2020 Sportafolio SAC. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum RequestType: String {
    case url = "url"
    case json = "json"
}

struct ResponseHelper {
    static func POST(with type: RequestType, url: String, headers: HTTPHeaders? = nil, parameters: [String: Any], success: @escaping(JSON) -> Void, failure: @escaping(Error) -> Void) {
        let encoding: ParameterEncoding
        switch type {
        case .url:
            encoding = URLEncoding.default
        case .json:
            encoding = JSONEncoding.default
        }
        Alamofire.request(url,
                   method: .post,
                   parameters: parameters,
                   encoding: encoding,
                   headers: headers)
        .responseJSON { (response) in
            validate(response: response, success: success, failure: failure)
        }
    }
    
    static func GET(with type: RequestType, url: String, headers: HTTPHeaders? = nil, parameters: [String: Any]?, success: @escaping(JSON) -> Void, failure: @escaping(Error) -> Void) {
        let encoding: ParameterEncoding
        switch type {
        case .url:
            encoding = URLEncoding.default
        case .json:
            encoding = JSONEncoding.default
        }
        Alamofire.request(url,
                   method: .get,
                   parameters: parameters,
                   encoding: encoding,
                   headers: headers)
        .responseJSON { (response) in
            validate(response: response, success: success, failure: failure)
        }
    }
    
    private static func validate(response: DataResponse<Any>, success: @escaping(JSON) -> Void, failure: @escaping(Error) -> Void) {
        switch response.result {
        case .failure(let error):
            print("AFError: \(error.localizedDescription)")
            failure(error)
        case .success(let value):
            let jsonObject = JSON(value)
            let isSuccessful = jsonObject["success"].boolValue
            print("Response: \(response.response?.statusCode ?? 0) - \(jsonObject)")
            guard isSuccessful else {
                let errorMessage = jsonObject["error"]["message"].stringValue
                failure(NSError(domain: "TPMT", code: 420, userInfo: ["message": errorMessage]))
                return
            }
            
            success(jsonObject["payload"])
        }
    }
}
