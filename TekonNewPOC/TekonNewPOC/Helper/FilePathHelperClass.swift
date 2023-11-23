//
//  FilePathHelperClass.swift
//  TekionPOC
//
//  Created by MA on 11/17/16.
//  Copyright © 2016 ICTC. All rights reserved.
//

import Foundation

func createFolder (folderName : String) {
    
    let dataPath = getDocumentDirectoriesPathURL().appendingPathComponent(folderName)
    if !isFolderExistAtPath(pathURL: dataPath) {
        do {
            try FileManager.default.createDirectory(atPath: dataPath.path, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print(error.localizedDescription)
        }
    }
}


func createFolderAtPath (folderName : String , pathURL : URL) {
    
    let dataPath = pathURL.appendingPathComponent(folderName)
    if !isFolderExistAtPath(pathURL: dataPath) {
        do {
            try FileManager.default.createDirectory(atPath: dataPath.path, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print(error.localizedDescription)
        }
    }
}


func isFolderExistAtPath (pathURL : URL) -> Bool {
    if FileManager.default.fileExists(atPath: pathURL.path) {
       return true
    }
        return false
}



func getFilePathFromBundel (fileName fileNameStr : String) -> String? {
    let BundleFilelPath = Bundle.main.path(forResource: fileNameStr, ofType: nil)
      return BundleFilelPath
}

func getDocumentDirectoriesPath () -> String {
    let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    return documentsPath
}


func getDocumentDirectoriesPathURL () -> URL {
    let documentsUrl = FileManager.default.urls(for: .documentDirectory, in:.userDomainMask).first!
    return documentsUrl
}



func getFileNameWithoutExtension (fileURL: URL) -> String  {
    let filename: NSString = getFileNameFromURL(fileURL: fileURL) as NSString
    let pathExtention = filename.pathExtension
    let pathPrefix = filename.deletingPathExtension
    return pathPrefix
}



func getFileExtensionFromURL (fileURL: URL) -> String  {
//    let url = URL(string: "http://hr-platform.nv5.pw/image/comp_1/pdf-test.pdf")
    return fileURL.pathExtension
}

func getFileNameFromURL (fileURL: URL) -> String  {
    return fileURL.lastPathComponent
}




func fileExistsAtpath (pathStr : String) -> Bool {
    let fileManager = FileManager.default
    let success = fileManager.fileExists(atPath: pathStr)
    return success
}


func saveFileInDocument (fileData : Data, fileName : String)  {
    
    do {
        let outputURL = getDocumentDirectoriesPathURL().appendingPathComponent(fileName)
        
        try fileData.write(to: outputURL)
        
    } catch {
        print("Error: \(error)")
    }
}


func saveFileAtPath (fileData : Data, fileURL : URL)  {
    do {
        try fileData.write(to: fileURL)
        
    } catch {
        print("Error: \(error)")
    }
}
