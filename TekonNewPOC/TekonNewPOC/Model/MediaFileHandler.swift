//
//  MediaFileHandler.swift
//  TekonNewPOC
//
//  Created by Muhammed Ayaz on 17/11/23.
//

import Foundation


func splitVideoInto5MBChunks(fileInfo: structFileInfo)  {
    
    //let filename: NSString = getFileName(fileURL: videoUrl) as NSString
//    let pathExtention = filename.pathExtension
//    let pathPrefix = filename.deletingPathExtension
//
//    let outputFileName = getFileName(fileURL: videoUrl)
//    let outpu1 = getDocumentDirectoriesPath().appending("/")
//    let output = outpu1.appending(outputFileName)
    
    
//    let selectedSize = getVideoSizeInMB(filePath: fileInfo.filePath)
//    let seconds = getVideoFileDurationInSeconds(videoUrl: fileInfo.fileURL)
    //let splitDuration: Int = Int(seconds / (selectedSize!/5))
    
    do {
        let data = try Data(contentsOf: fileInfo.fileURL)
        let dataLen = data.count
        //print("Data Size", data.count)
        let chunkSize = ((1024 * 1000) * 5) // MB
        //print("Chunk Size", chunkSize)
        let fullChunks = Int(dataLen / chunkSize)
        let totalChunks = fullChunks + (dataLen % 1024 != 0 ? 1 : 0)
        print("Chunk count", totalChunks)
        
        var chunks:[Data] = [Data]()
        for chunkCounter in 0..<totalChunks {
            var chunk:Data
            let chunkBase = chunkCounter * chunkSize
            var diff = chunkSize
            if(chunkCounter == totalChunks - 1) {
                diff = dataLen - chunkBase
            }
            
            let range:Range<Data.Index> = chunkBase..<(chunkBase + diff)
            chunk = data.subdata(in: range)
            chunks.append(chunk)
            print("The size is \(chunk.count)")
        }
        //self.chunksDataArray = chunks
        
        var chunkNumber = 1
        let DocumentPath  = getDocumentDirectoriesPathURL()
        createFolderAtPath(folderName: fileInfo.fileNameWithoutExt, pathURL: DocumentPath)
        
        for saveData in chunks {
            let chunkFolderPath = DocumentPath.appendingPathComponent(fileInfo.fileNameWithoutExt)
            createFolderAtPath(folderName: String(chunkNumber), pathURL: chunkFolderPath)
            
            let saveFileAtURL = chunkFolderPath.appendingPathComponent(String(chunkNumber))
            
            saveFileAtPath(fileData: saveData, fileURL: saveFileAtURL.appendingPathComponent(fileInfo.fileName))
            chunkNumber = chunkNumber + 1
        }
        
        print("Total Chunk", chunks.count)
    }catch{
        return
    }
}




func combainVideoOf5MBChunks (uploadFileDetails: StructUploadFileDetails)  {
    
}
