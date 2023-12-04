//
//  EnumClass.swift
//  TekonNewPOC
//
//  Created by Muhammed Ayaz on 18/11/23.
//

import Foundation

enum enumHttpMethod: String {
    case Post = "Post"
    case Put = "Put"
}


enum enumUploadStatus: String,Codable {
    case ReddyToUpload = "Reddy To Upload"
    case Uploding = "Uploding..."
    case UploadComplete = "Upload Complete."
    init(){
        self = enumUploadStatus.ReddyToUpload
    }
}
