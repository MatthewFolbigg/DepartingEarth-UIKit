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
    
    enum Endpoint {
        //MARK: URL Components - Base API
        //Provides acctual data but throttled. Use in release and real world testing.
        private static let apiUrl = "https://ll.thespacedevs.com/2.0.0/"
        //Provides Stale data but not throttled. Use when building and testing
        //private static let apiUrl = "https://lldev.thespacedevs.com/2.0.0/"
        private static let responseAsJson = "?format=json"
        
        //MARK: URL Components - Request Types
        private static let launches = "launch/"
        private static let upcomingLaunches = "launch/upcoming/"
        private static let agencies = "agencies/"
        
        //MARK: URL Components - Filters and Ordering
        private static let first30 = "&limit=30&offset=0"
        
        //MARK: Endpoint Cases
        case getUpcomingLaunches
        case getAgencyById(Int)
        
        //MARK: URL Construction
        var url: URL? { return URL(string: urlString) }
        
        private var urlString: String {
            switch self {
            case .getUpcomingLaunches:
                return Endpoint.apiUrl + Endpoint.upcomingLaunches + Endpoint.responseAsJson + Endpoint.first30
            case .getAgencyById(let agencyId):
                return Endpoint.apiUrl + Endpoint.agencies + "\(agencyId)"
            }
        }
    }
    
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

//MARK: Get Requests
extension LaunchLibraryApiClient {
    
    //MARK: Get Upcoming Launches
    static func getUpcomingLaunches(completion: @escaping ([LaunchInfo]?, Error?) -> Void) {
        let url = Endpoint.getUpcomingLaunches.url!
        print("Getting Upcoming Launches: \(url)")
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
            
                let decoder = JSONDecoder()
                do {
                    let jsonData = try decoder.decode(UpcomingLaunchApiResponse.self, from: data)
                    completion(jsonData.results, nil)
                
                } catch {
                    print("JSON Decoding Failed: \(error.localizedDescription)")
                    completion(nil, downloadError.decodingFailed)
                }
            }
        }
        task.resume()
    }
        
    //MARK: Get Agency Info by ID
    static func getAgencyInfo(id: Int, completion: @escaping (AgencyDetail? , Error?) -> Void) {
        guard let url = Endpoint.getAgencyById(id).url else {
            print("Invalid URL Created. Check Agency ID is valid")
            return
        }
        print("Getting Agency for ID \(id): \(url)")
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
                
                let decoder = JSONDecoder()
                do {
                    let agencyInfo = try decoder.decode(AgencyDetail.self, from: data)
                    completion(agencyInfo, nil)
                } catch {
                    completion(nil, downloadError.decodingFailed)
                }
            }
        }
        task.resume()
    }
    
    //MARK: Get Image from URL
    static func getImage(urlString: String, completion: @escaping (UIImage?, Error?) -> Void) {
        guard let url = URL(string: urlString) else {
            print("Invalid Logo URL")
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
}


