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
        //MARK: URL Components - Base API
        //Provides acctual data but throttled. Use in release and real world testing.
        //private static let apiUrl = "https://ll.thespacedevs.com/2.0.0/"
        //Provides Stale data but not throttled. Use when building and testing
        private static let apiUrl = "https://lldev.thespacedevs.com/2.0.0/"
        private static let responseAsJson = "?format=json"
        
        //MARK: URL Components - Request Types
        private static let launches = "launch/"
        private static let upcomingLaunches = "launch/upcoming/"
        
        //MARK: URL Components - Filters and Ordering
        private static let first50 = "&limit=50&offset=0"
        
        //MARK: Endpoint Cases
        case getUpcomingLaunches
        
        //MARK: URL Construction
        var url: URL { return URL(string: urlString)! }
        
        private var urlString: String {
            switch self {
            case .getUpcomingLaunches:
                return Endpoint.apiUrl + Endpoint.upcomingLaunches + Endpoint.responseAsJson + Endpoint.first50
            }
        }
    }
    
    //MARK: Get Request
    class func getUpcomingLaunches(completion: @escaping ([LaunchInfo]?, Error?, URLResponse?) -> Void) {
        let url = Endpoint.getUpcomingLaunches.url
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(nil, error, response)
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error, response)
                }
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let jsonData = try decoder.decode(LaunchLibraryApiResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(jsonData.results, nil, nil)
                }
            } catch {
                print("JSON Decoding Failed: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(nil, error, response)
                }
            }
        }
        task.resume()
    }
}
