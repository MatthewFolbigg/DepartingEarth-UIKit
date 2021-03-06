//
//  LaunchLibraryApiClient.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 30/03/2021.
//

import Foundation
import UIKit

class LaunchLibraryApiClient {
    //API Documentation: https://thespacedevs.com/llapi
    
    //MARK: Endpoints
    enum Endpoint {
        //URL Components - Base API
        private static let apiUrl = "https://ll.thespacedevs.com/2.0.0/" //Provides acctual data but throttled. Use in release and real world testing.
        //private static let apiUrl = "https://lldev.thespacedevs.com/2.0.0/" //Provides Stale data but not throttled. Use when building and testing
        private static let responseAsJson = "?format=json"
        private static let detailedMode = "?mode=detailed"
        
        //URL Components - Request Types
        private static let upcomingLaunches = "launch/upcoming/"
        private static let agencies = "agencies/"
        
        //URL Components - Filters and Ordering
        private static let first30 = "&limit=80&offset=0"
        
        //Endpoint Cases
        case getUpcomingLaunches
        case getAgencyById(Int)
        
        //URL Construction
        var url: URL? { return URL(string: urlString) }
        
        private var urlString: String {
            switch self {
            case .getUpcomingLaunches:
                return Endpoint.apiUrl + Endpoint.upcomingLaunches + Endpoint.detailedMode + "&" + Endpoint.responseAsJson + Endpoint.first30
            case .getAgencyById(let agencyId):
                return Endpoint.apiUrl + Endpoint.agencies + "\(agencyId)"
            }
        }
    }
}

//MARK: Get Requests
extension LaunchLibraryApiClient {
    
    //MARK: Get Upcoming Launches
    static func getUpcomingLaunches(completion: @escaping (UpcomingLaunchApiResponse?, Error?) -> Void) {
        let url = Endpoint.getUpcomingLaunches.url!
        print("Getting Upcoming Launches: \(url)")
        getJsonDataFromApi(url: url, resultType: UpcomingLaunchApiResponse.self, completion: completion)
    }
            
    static func getImage(urlString: String, completion: @escaping (UIImage?, Error?) -> Void) {
        guard let url = URL(string: urlString) else {
            print("\(#file) \(#function): Invalid Logo URL")
            return
        }
        print("Getting Image: \(url)")
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = setErrorType(error: error, response: response) {
                    completion(nil, error)
                    return
                }
                
                guard let data = data else {
                    completion(nil, downloadError.nilData)
                    return
                }
                
                if let image = UIImage(data: data) {
                    completion(image, nil)
                } else {
                    completion(nil, downloadError.decodingFailed)
                }
            }
        }
        task.resume()
    }
    
    static func getJsonDataFromApi<ResultType: Decodable>(url: URL, resultType: ResultType.Type, completion: @escaping (ResultType?, Error?) -> Void) {
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = setErrorType(error: error, response: response) {
                    completion(nil, error)
                    return
                }
                guard let data = data else {
                    completion(nil, downloadError.nilData)
                    return
                }
            
                if let decodedData = decodeLaunchLibraryResult(jsonData: data, to: resultType.self) {
                    completion(decodedData, nil)
                } else {
                    completion(nil, downloadError.decodingFailed)
                }
            }
        }
        task.resume()
    }
    
    static func decodeLaunchLibraryResult<ResultType: Decodable>(jsonData: Data, to resultType: ResultType.Type) -> ResultType? {
        let decoder = JSONDecoder()
        do {
            let jsonData = try decoder.decode(ResultType.self, from: jsonData)
            return jsonData
        
        } catch {
            print("\(#file) \(#function) JSON Decoding Failed: \(error.localizedDescription)")
            return nil
        }
    }
    
}

//MARK: Errors
extension LaunchLibraryApiClient {
    enum downloadError: Error, LocalizedError {
        case rateLimited
        case decodingFailed
        case nilData
        case dataTaskError
        
        var errorDescription: String? {
            switch self {
            case .dataTaskError: return "Comms Failure"
            case .rateLimited: return "Mission Control Busy"
            case .decodingFailed: return "Alien Data"
            case .nilData: return "Silence"
            }
        }
        var failureReason: String? {
            switch self {
            case .dataTaskError: return "Failed to reach mission control."
            case .rateLimited: return "Too many requests made to mission control."
            case .decodingFailed: return "Data was returned in an alien language."
            case .nilData: return "No resposne from mission control."
            }
        }
        var recoverySuggestion: String? {
            switch self {
            case .dataTaskError: return "Check your network connection and try again."
            case .rateLimited: return "Give them a break and try again in a few minutes."
            case .decodingFailed: return "The cryptographers look confused try again later."
            case .nilData: return "Try again."
            }
        }
    }
    
    private static func setErrorType(error: Error?, response: URLResponse?) -> Error? {
        if let error = error {
            print(error)
            return downloadError.dataTaskError
        }
        guard let httpResponse = response as? HTTPURLResponse else {
            return nil
        }
        if httpResponse.statusCode == 429 {
            return downloadError.rateLimited
        } else {
            return nil
        }
    }
    
}


