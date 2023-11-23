//
//  UserDefaltClass.swift
//  TekonNewPOC
//
//  Created by Muhammed Ayaz on 23/11/23.
//

import UIKit

class UserDefaltClass: NSObject {
    let UserDefaultsObj = UserDefaults.standard
    
    class UserDefaltClass {
        static let sharedInstance = UserDefaltClass()
    }
    
    
    func setUploadFileDetails(UploadFileDetails:StructUploadFileDetails) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(UploadFileDetails) {
            UserDefaultsObj.set(encoded, forKey: "SavedPerson")
        }
    }
    
    
//    func getUploadFileDetails() -> StructUploadFileDetails {
//        return UserDefaultsObj
//        
//        
//        
//        return UserDefaultsObj (forKey: "UploadFileDetails") as StructUploadFileDetails
//    }
    
}
