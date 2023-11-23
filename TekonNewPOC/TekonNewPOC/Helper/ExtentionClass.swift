//
//  ExtentionClass.swift
//  TekionPOC
//
//  Created by Muhammed Ayaz on 20/10/23.
//

import Foundation


extension URL {
     var attributes: [FileAttributeKey : Any]? {
         do {
             return try FileManager.default.attributesOfItem(atPath: path)
         } catch let error as NSError {
             print("FileAttribute error: \(error)")
         }
         return nil
     }

     var fileSize: UInt64 {
         return attributes?[.size] as? UInt64 ?? UInt64(0)
     }

     var fileSizeString: String {
         return ByteCountFormatter.string(fromByteCount: Int64(fileSize), countStyle: .file)
     }

     var creationDate: Date? {
         return attributes?[.creationDate] as? Date
     }
 }


extension String {
    func appendString (str : String) -> String {
        self.appending(str)
        return self
    }
    
    
    var appendDot : String {
        self.appending(".")
    }
    
    var appendSlash : String {
        self.appending("/")
    }
    var appendUnderscore : String {
        self.appending("_")
    }
}

extension DispatchQueue {

    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }
    /*
    //Usage
     
     DispatchQueue.background(delay: 3.0, background: {
         // do something in background
     }, completion: {
         // when background job finishes, wait 3 seconds and do something in main thread
     })

     DispatchQueue.background(background: {
         // do something in background
     }, completion:{
         // when background job finished, do something in main thread
     })

     DispatchQueue.background(delay: 3.0, completion:{
         // do something in main thread after 3 seconds
     })
     */

}
