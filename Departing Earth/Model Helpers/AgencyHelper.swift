//
//  Agencies.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 02/04/2021.
//

import Foundation
import CoreData
import UIKit

class AgencyHelper {
    
    static func getAgencyForId(id: Int, context: NSManagedObjectContext, completion: @escaping (LaunchAgency?, Error?) -> Void) {
        let fetchedAgencies = fetchSavedAgencies(context: context)
        for agency in fetchedAgencies {
            if agency.agencyId == id {
                completion(agency, nil)
                return
            }
        }
        LaunchLibraryApiClient.getAgencyInfo(id: id) { (agencyDetail, error) in
            if let error = error {
                completion(nil, error)
            }
            guard let agencyDetail = agencyDetail else {
                //MARK: Add custom error here
                completion(nil, error)
                return
            }
            let newAgency = createAgencyFrom(agencyDetail: agencyDetail, context: context)
            completion(newAgency, nil)
        }
    }
    
    static func getLogoFor(agency: LaunchAgency, context: NSManagedObjectContext, completion: @escaping (UIImage?, Error?) -> Void) {
        
        if agency.logo != nil {
            completion(UIImage(data: (agency.logo?.imageData)!), nil)
            return
        }
        
        guard let url = agency.logoUrl else {
            //MARK: Add custom error here to enable placeholder for agencies with no Logo URL
            completion(nil, nil)
            return
        }
        LaunchLibraryApiClient.getImage(urlString: url) { (image, error) in
            if let error = error {
                completion(nil, error)
            }
            guard let image = image else {
                if let error = error { print(error) }
                completion(nil, nil)
                return
            }
            let logo = AgencyLogo(context: context)
            logo.imageData = image.pngData()
            agency.logo = logo
            logo.agency = agency
            do { try context.save() } catch {print(error)}
            completion(image, nil)
        }
    }
        
    static private func createAgencyFrom(agencyDetail: AgencyDetail, context: NSManagedObjectContext) -> LaunchAgency {
        let agency = LaunchAgency(context: context)
        agency.name = agencyDetail.name
        agency.agencyId = Int64(agencyDetail.id)
        agency.logoUrl = agencyDetail.logoUrl
        agency.abbreviation = agencyDetail.abbreviation
        agency.type = agencyDetail.type
        let updatedAt = Date()
        agency.lastUpdated = updatedAt
        try? context.save()
        return agency
    }
        
    static private func fetchSavedAgencies(context: NSManagedObjectContext) -> [LaunchAgency] {
        let fetchRequest = NSFetchRequest<LaunchAgency>(entityName: "LaunchAgency")
        if let fetchedAgencies = try? context.fetch(fetchRequest) {
            return fetchedAgencies
        } else {
            return []
        }
    }
    
}
