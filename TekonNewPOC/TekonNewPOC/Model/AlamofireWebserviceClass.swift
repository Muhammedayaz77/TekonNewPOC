//
//  AlamofireWebserviceClass.swift
//  TekonNewPOC
//
//  Created by Muhammed Ayaz on 18/11/23.
//

import Foundation
import Alamofire


func APICreateMultipartUploadAlamofire(uploadFileDetails: StructUploadFileDetails, completionBlock: @escaping (StructAPIResCreateMultipartUpload) -> Void) {
    
    let url = baseURL.appending("createMultipartUpload")
    let fileName = uploadFileDetails.fileInfo!.fileName
    let params: [String: Any] = ["name": fileName, "mimeType": "video/mp4"]
    
    AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseData { response in
        
        switch response.result {
            case .success(let data):
             do {
                 guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                     print("Error converting data to JSON object")
                     return
                 }
                 guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                     print("Error converting JSON object to Pretty JSON data")
                     return
                 }
                 guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                     print("Error converting JSON data in String")
                     return
                 }
                 print(prettyPrintedJson)
                 
                 let apiResponse = try JSONDecoder().decode(StructAPIResCreateMultipartUpload.self, from: data)
                 completionBlock(apiResponse)
                 
        } catch {
            print("Error: Trying to convert JSON data to string")
            return
        }
        case .failure(let error):
            print(error)
        }
    }
}



func APIGetMultipartPreSignedUrlAlamofire (uploadFileDetails : StructUploadFileDetails, completionBlock: @escaping (StructAPIResMultipartPreSignedURL) -> Void) {
    
    let url = baseURL.appending("getMultipartPreSignedUrls")
    let fileNumberOfChuncks : Int = uploadFileDetails.totalNumberOfChuncks!
    let fileKey = uploadFileDetails.ResCreateMultipartUpload!.fileKey
    let uploadId = uploadFileDetails.ResCreateMultipartUpload!.UploadId
    let params: [String: Any] = ["fileKey":fileKey, "UploadId": uploadId, "parts":String(fileNumberOfChuncks)]
    
    AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseData { response in
        
        switch response.result {
            case .success(let data):
             do {
                 guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                     print("Error converting data to JSON object")
                     return
                 }
                 guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                     print("Error converting JSON object to Pretty JSON data")
                     return
                 }
                 guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                     print("Error converting JSON data in String")
                     return
                 }
                 print(prettyPrintedJson)
                 let apiResponse = try JSONDecoder().decode(StructAPIResMultipartPreSignedURL.self, from: data)
                 completionBlock(apiResponse)
                 
        } catch {
            print("Error: Trying to convert JSON data to string")
            return
        }
        case .failure(let error):
            print(error)
        }
    }
}




func APIUploadAlamofire (uploadFileDetails : StructUploadFileDetails, index : Int, completionBlock: @escaping (StructAPIResUploadedFile) -> Void) {
    
    let headers: HTTPHeaders = ["Connection": "keep-alive",        "Content-Type" : ""]
    let preSignedUrl: StructPreSigned = uploadFileDetails.MultiPartPreSignedUrlArray!.parts[index]
    let localURL = uploadFileDetails.chunkFileURLArray[index].appendingPathComponent(uploadFileDetails.fileInfo!.fileName)
    let parameters = localURL.path
    let postData = parameters.data(using: .utf8)
    let eTag: String = uploadFileDetails.ETagArray[index]
    if eTag != "" {
        print("not empty");
        return
    }
    
    
    AF.upload(postData!, to: preSignedUrl.signedUrl, method: .put, headers: headers)
        .responseData { response in
            print(":::::::::: actul responce ",response)
            
            var output = StructAPIResUploadedFile(Etag: "", ResponceURL: (response.request?.url)!)
            
            if let res = response.response {
                if let url = response.request?.url {
                    print(":::::::::: allHeaderFields : \(res.allHeaderFields)")
                }
                
            for (key, value) in res.allHeaderFields {
                if key as! String == "Etag" {
                    output.Etag = value as! String
                }
            }
                print(":::::::::: ")
            completionBlock(output)
        }
    }
}





func APICompleteMultipartUploadAlamofire (uploadFileDetails : StructUploadFileDetails, completionBlock: @escaping (Any) -> Void)  {
    
    let url = baseURL.appending("completeMultipartUpload")
    
    let fileKey = uploadFileDetails.ResCreateMultipartUpload!.fileKey
    let uploadId = uploadFileDetails.ResCreateMultipartUpload!.UploadId
    
    var partArray = [Any]()
    for i in 0...uploadFileDetails.ETagArray.count-1 {
        let partNumber =  uploadFileDetails.MultiPartPreSignedUrlArray?.parts[i].partNumber
        let eTag: String = uploadFileDetails.ETagArray[i]
        if eTag == "" {
            print("empty");
        }
        let dictionaryA = ["PartNumber": "\(partNumber!)", "ETag": eTag]
        partArray.append(dictionaryA)
    }
    //let partDic : [String:Any] = ["parts":partArray]
    
    let params: [String: Any] = ["fileKey":fileKey, "UploadId": uploadId, "parts":partArray]
    
    print("params",params)
        
    AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseData { response in
            
        switch response.result {
            case .success(let data):
            do {
                guard let jsonObject = try
                            JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    print("Error converting data to JSON object")
                    return
                }
                guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                    print("Error converting JSON object to Pretty JSON data")
                    return
                }
                guard String(data: prettyJsonData, encoding: .utf8) != nil else {
                    print("Error converting JSON data in String")
                    return
                }
                print(response)
                completionBlock(data)
                
            } catch {
                print("Error: Trying to convert JSON data to string")
                return
        }
        case .failure(let error):
            print(error)
        }
    }
}



