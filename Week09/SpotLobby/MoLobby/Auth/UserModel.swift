//
//  UserViewModel.swift
//  MoGallery
//
//  Created by jht2 on 12/19/22.
//

import Foundation
import MapKit
import Observation

@Observable class UserModel: Identifiable {
    
    @ObservationIgnored var id: String
    @ObservationIgnored var name: String
    @ObservationIgnored var email: String
    @ObservationIgnored var profileImg: String
    @ObservationIgnored var dateIn: Date
    @ObservationIgnored var uploadCount: Int
    @ObservationIgnored var activeCount: Int
    @ObservationIgnored var stats: [String:Any];
    var caption: String

    // Week09: where I'm sitting, read from the dict the same way as caption
    var zone: String
    var zoneDate: Date

    // @ObservationIgnored var activeLapse: TimeInterval
    @ObservationIgnored var info:[String: Any] = [:]
    
    // Week09: a check in only counts for 3 hours, in case someone forgets to leave
    var isOnFloor: Bool {
        !zone.isEmpty && Date().timeIntervalSince(zoneDate) < 3 * 60 * 60
    }

    var activeCountLabel: String? {
        if activeCount > 0 { return "signin: "+String(activeCount) }
        return nil
    }
    
    var userGalleryKey: String {
        let nemail = email.replacingOccurrences(of: ".", with: "-")
        let str = "zu-\( id )-\( nemail )"
        // print("userGalleryKey", str)
        return str
    }
    
    init(id: String, dict: [String: Any]) {
        let name = dict["name"] as? String ?? ""
        let email = dict["email"] as? String ?? ""
        let profileImg = dict["profileImg"] as? String ?? ""
        let dateIn = dict["dateIn"] as? TimeInterval ?? 0
        let uploadCount = dict["uploadCount"] as? Int ?? 0
        let activeCount = dict["activeCount"] as? Int ?? 0
        let caption = dict["caption"] as? String ?? ""
        let stats = dict["stats"] as? [String:Any] ?? [String:Any]()
        // Week09:
        let zone = dict["zone"] as? String ?? ""
        let zoneDate = dict["zoneDate"] as? TimeInterval ?? 0
        
        self.id = id
        self.name = name;
        self.email = email
        self.profileImg = profileImg
        self.dateIn = Date(timeIntervalSinceReferenceDate: dateIn);
        self.uploadCount = uploadCount
        self.activeCount = activeCount
        self.caption = caption
        self.stats = stats
        // Week09:
        self.zone = zone
        self.zoneDate = Date(timeIntervalSinceReferenceDate: zoneDate)
        
        self.info = dict
        // info["lat
        // info["lon
    }
}

extension UserModel {
    var locationDescription: String? {
        guard let lat = info["lat"] as? Double else { return nil }
        guard let lon = info["lon"] as? Double else { return nil }
        return "\( String(format: "%.6f", lat) ) \( String(format: "%.6f", lon) )"
    }
//    var loc: Location? {
//        guard let lat = info["lat"] as? Double else { return nil }
//        guard let lon = info["lon"] as? Double else { return nil }
//        return Location(id: email, latitude: lat, longitude: lon, label: email)
//    }
}
