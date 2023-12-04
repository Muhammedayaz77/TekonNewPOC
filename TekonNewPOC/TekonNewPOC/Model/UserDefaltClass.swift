//
//  UserDefaltClass.swift
//  TekonNewPOC
//
//  Created by Muhammed Ayaz on 23/11/23.
//

import UIKit

class UserDefaltClass: NSObject {
    static let shared = UserDefaltClass()
    let UserDefaultsObj = UserDefaults.standard
    
    
    
    func setUploadFileDetails(UploadFileDetails:[StructUploadFileDetails]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(UploadFileDetails) {
            UserDefaultsObj.set(encoded, forKey: "UploadFileDetails")
        }
        
        g_LogString.appendString(str: "Save in UserDefaltClass")
    }
    
    
    func getUploadFileDetails() -> [StructUploadFileDetails]? {
        if let UploadFileDetails = UserDefaultsObj.object(forKey: "UploadFileDetails") as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode([StructUploadFileDetails].self, from: UploadFileDetails) {
                
                
                
                g_LogString.appendString(str: "get from UserDefaltClass")
                
                #if targetEnvironment(simulator)
                    // your simulator code
                    let loadedData = updateFilePath (UploadFileDetail: loadedPerson)
                    return loadedData
                #else
                    // your real device code
                return loadedPerson
                #endif
            }
        }
        return nil
    }
    
    
    
    func updateFilePath (UploadFileDetail :[StructUploadFileDetails]) -> [StructUploadFileDetails] {
        
        var UploadFileDetailsArr = UploadFileDetail
        
        let DocumentPathStr = getDocumentDirectoriesPath()
        let DocumentURL = getDocumentDirectoriesPathURL()
        let fileManager = FileManager.default
        
        for (index, UploadFileDetail) in UploadFileDetailsArr.enumerated().reversed() {
            
            let fileNameStr = (UploadFileDetail.fileInfo?.fileName)!
            let filePath = DocumentPathStr.appendSlash.appendString(str: fileNameStr)
            
            
            //filePath Updated
            UploadFileDetailsArr[index].fileInfo?.filePath = filePath
            
            //fileURL Updated
            UploadFileDetailsArr[index].fileInfo?.fileURL = DocumentURL.appendingPathComponent(fileNameStr)
            

            let folderPath = DocumentURL.appendingPathComponent(UploadFileDetailsArr[index].fileInfo!.fileNameWithoutExt)
            
            let chunkFileURLArray = try! fileManager.contentsOfDirectory(at: folderPath, includingPropertiesForKeys: nil).sorted { $0.path < $1.path }
            
            var chunkFilePathArray = [String]()
            for url in chunkFileURLArray {
                //chunkFilePathArray.append(try! String(contentsOf: url))
                chunkFilePathArray.append(url.path)
            }
            
            UploadFileDetailsArr[index].chunkFileURLArray = chunkFileURLArray
            UploadFileDetailsArr[index].chunkFilePathArray = chunkFilePathArray
            
        }
        
        return UploadFileDetailsArr
    }
    
}
