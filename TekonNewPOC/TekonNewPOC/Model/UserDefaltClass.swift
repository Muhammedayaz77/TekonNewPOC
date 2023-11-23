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
            UserDefaultsObj.set(encoded, forKey: "UploadFileDetails")
        }
    }
    
    
    func getUploadFileDetails() -> StructUploadFileDetails? {
       
        if let savedPerson = UserDefaultsObj.object(forKey: "UploadFileDetails") as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(StructUploadFileDetails.self, from: savedPerson) {
                return loadedPerson
            }
        }
        return nil
    }
    
}
