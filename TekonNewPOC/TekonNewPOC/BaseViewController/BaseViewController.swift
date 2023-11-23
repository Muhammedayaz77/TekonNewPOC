//
//  BaseViewController.swift
//  TekionPOC
//
//  Created by Muhammed Ayaz on 19/10/23.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    /*
    func APICreateMultipartUpload (uploadFileDetails : structUploadFileDetails) {
        //let parameters = "{\n    \"name\":\"test.mp4\",\n    \"mimeType\":\"video/mp4\"\n}"
        
        
        let fileName = uploadFileDetails.fileInfo.fileName
        let fileExtention = uploadFileDetails.fileInfo.fileExtention
        
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
        
    //    let apiStr = baseURL.appendString(str: "createMultipartUpload")
        let apiStr = baseURL.appending("createMultipartUpload")
        
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
     */


}

