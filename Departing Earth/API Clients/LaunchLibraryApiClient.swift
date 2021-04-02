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
        //private static let apiUrl = "https://ll.thespacedevs.com/2.0.0/"
        //Provides Stale data but not throttled. Use when building and testing
        private static let apiUrl = "https://lldev.thespacedevs.com/2.0.0/"
        private static let responseAsJson = "?format=json"
        
        //MARK: URL Components - Request Types
        private static let launches = "launch/"
        private static let upcomingLaunches = "launch/upcoming/"
        private static let agencies = "agencies/"
        
        //MARK: URL Components - Filters and Ordering
        private static let first50 = "&limit=50&offset=0"
        
        //MARK: Endpoint Cases
        case getUpcomingLaunches
        case getAgencyById(Int)
        
        //MARK: URL Construction
        var url: URL? { return URL(string: urlString) }
        
        private var urlString: String {
            switch self {
            case .getUpcomingLaunches:
                return Endpoint.apiUrl + Endpoint.upcomingLaunches + Endpoint.responseAsJson + Endpoint.first50
            case .getAgencyById(let agencyId):
                return Endpoint.apiUrl + Endpoint.agencies + "\(agencyId)"
            }
        }
    }
}

//MARK: Get Requests
extension LaunchLibraryApiClient {
    
    //MARK: Get Upcoming Launches
    static func getUpcomingLaunches(completion: @escaping ([LaunchInfo]?, Error?, URLResponse?) -> Void) {
        let url = Endpoint.getUpcomingLaunches.url!
        print("Getting Upcoming Launches: \(url)")
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
                let jsonData = try decoder.decode(UpcomingLaunchApiResponse.self, from: data)
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
    
    //MARK: Get Agency Info by ID
    static func getAgencyInfo(id: Int, completion: @escaping (AgencyDetail? , Error?, URLResponse?) -> Void) {
        guard let url = Endpoint.getAgencyById(id).url else {
            print("Invalid URL Created. Check Agency ID is valid")
            return
        }
        print("Getting Agency for ID \(id): \(url)")
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
                let agencyInfo = try decoder.decode(AgencyDetail.self, from: data)
                DispatchQueue.main.async {
                    completion(agencyInfo, nil, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error, response)
                }
            }
        }
        task.resume()
    }
    
    //MARK: Get Image from URL
    static func getImage(urlString: String, completion: @escaping (UIImage?, Error?, URLResponse?) -> Void) {
        guard let url = URL(string: urlString) else {
            print("Invalid Logo URL")
            return
        }
        print("Getting Image: \(url)")
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
            
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image, nil, nil)
                }
            }
        }
        task.resume()
    }
}


