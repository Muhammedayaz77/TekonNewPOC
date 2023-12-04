//
//  StructureClass.swift
//  TekonNewPOC
//
//  Created by Muhammed Ayaz on 17/11/23.
//

import Foundation



struct StructUploadFileDetails : Codable {
    var fileInfo: StructFileInfo?
    var chunkFilePathArray = [String]()
    var chunkFileURLArray = [URL]()
    var totalNumberOfChuncks: Int?
    var ETagArray = [String]()
    var MultiPartPreSignedUrlArray : StructAPIResMultipartPreSignedURL?
    var ResCreateMultipartUpload : StructAPIResCreateMultipartUpload?
    var uploadStatus : enumUploadStatus?
    
}





struct StructFileInfo : Codable{
    var fileName: String
    var filePath: String
    var fileExtention: String
    var fileURL : URL
    var fileNameWithoutExt: String
}


struct StructPreSigned: Codable {
    var signedUrl: String
    var partNumber: Int
    
    enum CodingKeys: String, CodingKey {
        case signedUrl
        case partNumber = "PartNumber"
    }
}

struct StructAPIResMultipartPreSignedURL: Codable {
    let parts: [StructPreSigned]
}

struct StructAPIResCreateMultipartUpload: Codable {
    var UploadId: String
    var fileKey: String
}


struct StructAPIResUploadedFile: Codable {
    var Etag: String
    var ResponceURL: URL
}



