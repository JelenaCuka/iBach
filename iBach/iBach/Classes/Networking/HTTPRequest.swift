//
//  HTTPRequest.swift
//  iBach
//
//  Created by Petar Jedek on 22.11.18.
//  Copyright © 2018 Petar Jedek. All rights reserved.
//

import Alamofire

class HTTPRequest {
    
    public func sendPostRequest(urlString: String, parameters: Parameters, completionHandler: @escaping ([String: Any]?, NSError?) -> ()) {
        
        let url = URL(string: urlString)
        
        Alamofire.request(url!, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate { request, response, data in
                return .success
            }
            .responseJSON { response in
                completionHandler(response.result.value as? [String: Any], response.result.error as? NSError)
            }
    }
    
    public func sendGetRequest(urlString: String, completionHandler: @escaping ([String: Any]?, NSError?) -> ()) {
        
        let url = URL(string: urlString)
        
        Alamofire.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default)
            .validate { request, response, data in
                return .success
            }
            .responseJSON { response in
                completionHandler(response.result.value as? [String: Any], response.result.error as? NSError)
        }
    }
    
}
