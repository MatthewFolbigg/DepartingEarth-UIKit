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
            
    static func getAgencyForId(id: Int, context: NSManagedObjectContext, completion: @escaping (LaunchAgency?) -> Void) {
        
        let fetchedAgencies = fetchSavedAgencies(context: context)
        
        for agency in fetchedAgencies {
            if agency.agencyId == id {
                completion(agency)
                print("Returned Existing Agency")
                return
            }
        }
        
        LaunchLibraryApiClient.getAgencyInfo(id: id) { (agencyDetail, error, response) in
            guard let agencyDetail = agencyDetail else {
                if let error = error { print(error) }
                completion(nil)
                return
            }
            let newAgency = createAgencyFrom(agencyDetail: agencyDetail, context: context)
            print("Returned New Agency")
            completion(newAgency)
        }
    }
    
    static func getLogoFor(agency: LaunchAgency, context: NSManagedObjectContext, completion: @escaping (AgencyLogo?) -> Void) {
        if agency.logo != nil {
            completion(agency.logo)
            return
        }
        guard let url = agency.logoUrl else {
            //NO IMAGE AVAILABLE, LOGO URL NIL
            print("No Logo URL")
            completion(nil)
            return
        }
        LaunchLibraryApiClient.getImage(urlString: url) { (image, error, response) in
            guard let image = image else {
                if let error = error { print(error) }
                completion(nil)
                return
            }
            let logo = AgencyLogo(context: context)
            logo.imageData = image.pngData()
            agency.logo = logo
            try? context.save()
            completion(agency.logo)
        }
        
    }
        
    static private func createAgencyFrom(agencyDetail: AgencyDetail, context: NSManagedObjectContext) -> LaunchAgency {
        let agency = LaunchAgency(context: context)
        agency.name = agencyDetail.name
        agency.agencyId = Int64(agencyDetail.id)
        agency.logoUrl = agencyDetail.logoUrl
        agency.abbreviation = agencyDetail.abbreviation
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
