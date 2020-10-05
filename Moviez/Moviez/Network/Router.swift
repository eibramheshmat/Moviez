//
//  Router.swift
//  Moviez
//
//  Created by Ibram on 10/5/20.
//  Copyright © 2020 Ibram. All rights reserved.
//  Router enum about prepare API Requests.

import Foundation

enum Router {
    case getMovieImages(movieName: String)
    
    private static let baseURLString = Bundle.main.baseURL
    
    private enum HTTPMethod {
        case get
        case post
        case put
        case delete
        
        var value: String {
            switch self {
            case .get: return "GET"
            case .post: return "POST"
            case .put: return "PUT"
            case .delete: return "DELETE"
            }
        }
    }
    
    private var method: HTTPMethod {
        switch self {
        case .getMovieImages: return .get
        }
    }
    
    private var path: String {
        switch self {
        case .getMovieImages:
            return ""
        }
    }
    
    private var params: [String:Any] {
        switch self {
        case .getMovieImages(let movieName):
            let paramsData = PhotoRequestParams(apiKey: Bundle.main.appKey, method: "flickr.photos.search", format: "json", nojsoncallback: "1",text: movieName+" movie")
            return paramsData.dictionary ?? [:]
        }
    }
    
    func request() throws -> URLRequest {
        var urlString = ""
        if method.value == "GET"{
            urlString = "\(Router.baseURLString)\(path)?\(params.queryString.replacingOccurrences(of: " ", with: "%20"))"
        }else{
            urlString = "\(Router.baseURLString)\(path)"
        }
        
        guard let url = URL(string: urlString) else {
            throw ErrorType.parseUrlFail
        }
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 10)
        request.httpMethod = method.value
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        switch self {
        case .getMovieImages:
            return request
        }
    }
}
