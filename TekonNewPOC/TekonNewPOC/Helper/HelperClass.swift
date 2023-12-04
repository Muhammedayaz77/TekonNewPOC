//
//  HelperClass.swift
//  TekionPOC
//
//  Created by Muhammed Ayaz on 04/11/23.
//

import Foundation
import AVFoundation
import UIKit


func runOnMainQueue(_ block: @escaping () -> Void) {
    DispatchQueue.main.async {
        block()
    }
}




func getVideoSizeInMB(filePath: String) -> Double? {
    let fileManager = FileManager.default
    
    // Check if the file exists
    if fileManager.fileExists(atPath: filePath) {
        do {
            // Get the file attributes
            let fileAttributes = try fileManager.attributesOfItem(atPath: filePath)
            
            // Extract the file size in bytes
            if let fileSize = fileAttributes[.size] as? UInt64 {
                // Convert bytes to megabytes (1 MB = 1024 * 1024 bytes)
                let fileSizeInMB = Double(fileSize) / (1024 * 1024)
                return fileSizeInMB
            } else {
                return nil // Failed to get file size
            }
        } catch {
            print("Error: \(error)")
            return nil
        }
    } else {
        return nil // File does not exist
    }
}


func getVideoFileDuration (videoUrl: URL) -> String  {
    
    let asset = AVAsset(url: videoUrl)
    
    // Access the duration of the video
    let durationInSeconds = CMTimeGetSeconds(asset.duration)
    
    // Convert the duration to a human-readable format
    let durationText = formatTime(seconds: durationInSeconds)
    
    return durationText
}


func formatTime(seconds: Double) -> String {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.hour, .minute, .second]
    formatter.unitsStyle = .positional
    formatter.zeroFormattingBehavior = .pad
    return formatter.string(from: seconds) ?? "00:00"
}


func getVideoFileDurationInSeconds (videoUrl: URL) -> Double  {
    
    let asset = AVAsset(url: videoUrl)
    
    // Access the duration of the video in seconds
    let durationInSeconds = CMTimeGetSeconds(asset.duration)
    return durationInSeconds
}




func createThumbnailOfVideo(url :URL) -> UIImage? {
//
//    let asset = AVAsset(url: URL(string: url)!)
    let asset = AVAsset(url: url)
    let assetImgGenerate = AVAssetImageGenerator(asset: asset)
    assetImgGenerate.appliesPreferredTrackTransform = true
    //Can set this to improve performance if target size is known before hand
    //assetImgGenerate.maximumSize = CGSize(width,height)
    let time = CMTimeMakeWithSeconds(1.0, preferredTimescale: 600)
    do {
        let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
        let thumbnail = UIImage(cgImage: img)
//        let fileName = getFileNameWithoutExtension(fileURL: url).appendDot.appendString(str: "jpeg")
//        
//        let thumbnailData = thumbnail.jpegData(compressionQuality: 1)!
//        saveFileInDocument(fileData: thumbnailData, fileName:fileName)
        
        return thumbnail
    } catch {
        print(error.localizedDescription)
        AlertManager.sharedInstance.alertWindow(title: "Error createThumbnailOfVideo", message: error.localizedDescription)
        return nil
    }
}

func initializeCell (aTableView: UITableView, cellIdentifier: String) {
     aTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
}

func initializeCellWithIdentifier (aTableView: UITableView, nibName: String, cellIdentifier: String) {
    aTableView.register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: cellIdentifier)
}
