//
//  RequesterProtocol.swift
//  GitHubList
//
//  Created by George Gomes on 01/07/23.
//
import Foundation
import Alamofire

protocol RequesterProtocol { }

extension RequesterProtocol {
    
    // Generic function to call Alamofire and return espected type
    func makeRequest<T>(url: String, urlParams: [String: String] = [:], single: @escaping (Result<T, Error>) -> Void) where T: Decodable {
        AF.request(url, parameters: urlParams)
            .responseDecodable(of: T.self) { (response) in

                switch response.result {
                case .success(let result):
                    single(.success(result))
                case .failure(let error):
                    guard let statusCode = response.response?.statusCode else {
                        single(.failure(error))
                        return
                    }
                    
                    if statusCode == 404 {
                        single(.failure(GitHubServiceError.notFound))
                    }
                    
                    single(.failure(error))
                }
        }
    }
    
    func makeRequestForImage(url: String, single: @escaping (Result<Data, Error>) -> Void) {
        AF.request(url).responseData { response in
                switch response.result {
                case .success(let result):
                    single(.success(result))
                case .failure(let error):
                    single(.failure(error))
                }
        }
    }
}
