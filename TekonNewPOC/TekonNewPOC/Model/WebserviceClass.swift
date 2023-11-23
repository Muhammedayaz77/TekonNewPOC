//
//  WebserviceClass.swift
//  TekonNewPOC
//
//  Created by Muhammed Ayaz on 18/11/23.
//

import Foundation
//createMultipartUpload
//getMultipartPreSignedUrl
//completeMultipartUpload



let baseURL : String = "http://13.57.38.104:8080/uploads/"


func APICreateMultipartUpload1 (uploadFileDetails : StructUploadFileDetails, completionBlock: @escaping (StructAPIResCreateMultipartUpload) -> Void) {
    
    let fileName = uploadFileDetails.fileInfo!.fileName
    let dictionary = ["name":fileName, "mimeType": "video/mp4"] as [String : Any]
    var parameters: String = ""
    
        // Convert the dictionary to a JSON string
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: [])
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print(jsonString)
                parameters = jsonString
            }
        } catch {
            print("Error converting dictionary to JSON: \(error)")
        }
    
    let postData = parameters.data(using: .utf8)
    let apiStr = baseURL.appending("createMultipartUpload")
    
    var request = URLRequest(url: URL(string: apiStr)!,timeoutInterval: Double.infinity)
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpMethod = enumHttpMethod.Post.rawValue
    request.httpBody = postData

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
    guard let data = data else {
        print(String(describing: error))
        return
    }
    print(String(data: data, encoding: .utf8)!)
        
        do {
            let apiResponse = try JSONDecoder().decode(StructAPIResCreateMultipartUpload.self, from: data)
            // Now you can access the data in the API response
            completionBlock(apiResponse)
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
    
    task.resume()
}

//----------------------------------------------------------------
//----------------------------------------------------------------
//responce in array decler it array


func APIGetMultipartPreSignedUrl (uploadFileDetails : StructUploadFileDetails, completionBlock: @escaping (StructAPIResMultipartPreSignedURL) -> Void) {
    
//    let parameters = "{\n    \"fileKey\":\"test.mp4\",\n    \"UploadId\": \"T4IbyEEMEbRzqrJ6FQn7te70biWw04R5UQ5OJlQH0fSDE_maaTnCz_yaiH_BC90oYfN.KGbLxS3yYz_.AyLBiFnEYaqZuvbaaE_lWxd3G_CcLtqw6FO6eXf9XmqV1BiH\",\n    \"parts\": 4\n}"
    
    let fileNumberOfChuncks : Int = uploadFileDetails.totalNumberOfChuncks!
    let fileKey = uploadFileDetails.ResCreateMultipartUpload!.fileKey
    let uploadId = uploadFileDetails.ResCreateMultipartUpload!.UploadId
    
    let dictionary = ["fileKey":fileKey, "UploadId": uploadId, "parts":String(fileNumberOfChuncks)] as [String : Any]
    
    var parameters: String = ""
    
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: [])
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            print(jsonString)
            parameters = jsonString
        }
    } catch {
        print("Error converting dictionary to JSON: \(error)")
    }
    
    let postData = parameters.data(using: .utf8)
    let apiStr = baseURL.appending("getMultipartPreSignedUrls")
    var request = URLRequest(url: URL(string: apiStr)!,timeoutInterval: Double.infinity)
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    request.httpBody = postData

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data else {
            print(String(describing: error))
            return
        }
        print(String(data: data, encoding: .utf8)!)
            do {
                let apiResponse = try JSONDecoder().decode(StructAPIResMultipartPreSignedURL.self, from: data)
                
                completionBlock(apiResponse)
                
//                let items = apiResponse.parts
//                for item1 in items {
//                    print(item1.partNumber)
//                    print(item1.signedUrl)
//                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
    }

    task.resume()
}



//----------------------------------------------------------------
//----------------------------------------------------------------




func APICompleteMultipartUpload (uploadFileDetails : StructUploadFileDetails , createMultipartUpload : StructAPIResCreateMultipartUpload, completionBlock: @escaping (StructAPIResMultipartPreSignedURL) -> Void) {
    
//    let parameters = "{\n    \"fileKey\": \"test.mp4\",\n    \"UploadId\": \"ovUA4fuCn_bx.evupl3lOJS6JViqPtyMLljn7JTJTrPGgCVti_SZMxP61VEPJyBSoE9JBKzV93uTCgZKwxhaNeNYEPXMtaMaN_wrh7LR4qwQcP090RM58ReyRmnfy3n1\",\n    \"parts\": [\n        {\n            \"PartNumber\": 1,\n            \"ETag\": \"tag number obtained after upload of part\"\n        },\n        {\n            \"PartNumber\": 2,\n            \"ETag\": \"tag number obtained after upload of part\"\n        },\n        {\n            \"PartNumber\": 3,\n            \"ETag\": \"tag number obtained after upload of part\"\n        },\n        {\n            \"PartNumber\": 4,\n            \"ETag\": \"tag number obtained after upload of part\"\n        }\n    ]\n}"
    
    
    
    let fileKey = createMultipartUpload.fileKey
    let uploadId = createMultipartUpload.UploadId
    //let parts = structAPIResMultipartPreSignedUrl(parts: <#T##[StructPart]#>)
    
    
    let dictionary = ["fileKey":fileKey, "UploadId": uploadId] as [String : Any]
    
    var parameters: String = ""
    
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: [])
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            print(jsonString)
            parameters = jsonString
        }
    } catch {
        print("Error converting dictionary to JSON: \(error)")
    }
    
    
    
    
    
    
    let postData = parameters.data(using: .utf8)
    
    let apiStr = baseURL.appending("completeMultipartUpload")
    
    var request = URLRequest(url: URL(string: apiStr)!,timeoutInterval: Double.infinity)
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")

    request.httpMethod = "POST"
    request.httpBody = postData

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      guard let data = data else {
        print(String(describing: error))
        return
      }
      print(String(data: data, encoding: .utf8)!)
    }

    task.resume()

    
}





func APIUpload(uploadFileDetails: StructUploadFileDetails, index : Int) {
    
    let preSignedUrl : StructPreSigned  = uploadFileDetails.MultiPartPreSignedUrlArray!.parts[index]
    let localURL = uploadFileDetails.chunkFileURLArray[index].appendingPathComponent(uploadFileDetails.fileInfo!.fileName)
    let parameters = localURL.path
    let postData = parameters.data(using: .utf8)
    
    var request = URLRequest(url: URL(string: preSignedUrl.signedUrl)!,timeoutInterval: Double.infinity)
    //request.addValue("text/plain", forHTTPHeaderField: "Content-Type")

    request.httpMethod = "PUT"
    request.httpBody = postData

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      guard let data = data else {
        print(String(describing: error))
        return
      }
        
        if let res = response as? HTTPURLResponse {
               res.allHeaderFields.forEach { (arg0) in
                  let (key, value) = arg0
                   
                   print(key)
                   print(value)
                   if key as! String == "Etag" {
                      // uploadFileDetails.ETagArray[index].append(value as! String)
                   }
               }
           }
      print(String(data: data, encoding: .utf8)!)
    }

    task.resume()

    
}

