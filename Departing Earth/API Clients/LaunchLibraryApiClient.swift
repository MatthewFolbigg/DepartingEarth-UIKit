//
//  LaunchLibraryApiClient.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 30/03/2021.
//

import Foundation

class LaunchLibraryApiClient {
    //API Documentation: https://thespacedevs.com/llapi
    
    var test = "Test"
    
    enum Endpoint {
        //MARK: URL Components
        private static let apiUrl = "https://ll.thespacedevs.com/2.0.0/"
        private static let responseAsJson = "?format=json"
        private static let launches = "launch/"
        
        //MARK: Endpoint Cases
        case getLaunches
        
        //MARK: URL Construction
        var url: URL? { return URL(string: urlString) }
        
        private var urlString: String {
            switch self {
            case .getLaunches:
                return Endpoint.apiUrl + Endpoint.launches + Endpoint.responseAsJson
            }
        }
    }
    
    //MARK: Get Request
    class func getLaunches(completion: @escaping ([LaunchInfo]?, Error?) -> Void) {
        guard let url = Endpoint.getLaunches.url else {
            print("Endpoint does not provide a valid URL")
            return
        }
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            //TODO: Add error handling
            if let error = error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            guard let data = data else {
                print("No data returned from request")
                return
            }
            let decoder = JSONDecoder()
            guard let jsonData = try? decoder.decode(LaunchLibraryApiResponse.self, from: data) else {
                print("Unable to Decoding JSON from data to LaunchLibraryResponse")
                return
            }
            
            DispatchQueue.main.async {
                completion(jsonData.results, nil)
            }
        }
        task.resume()
    }
}
