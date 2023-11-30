//
//  MediaDetailsViewController.swift
//  TekonNewPOC
//
//  Created by Muhammed Ayaz on 29/11/23.
//

import UIKit

class MediaDetailsViewController: BaseViewController {
    
    @IBOutlet weak var uploadStatusLabel: UILabel!
    @IBOutlet weak var uploadPresentLabel: UILabel!
    @IBOutlet weak var uploadProgressBar: UIProgressView!
    
    //declar Globale vaibale for access in all over
    var g_UploadFileDetails : StructUploadFileDetails = StructUploadFileDetails()
    
    
    
    override func viewDidLoad() {
        
        print("g_UploadFileDetailsArray",g_UploadFileDetailsArray)
        
        
        g_UploadFileDetails = g_UploadFileDetailsArray[g_selectedFileIndex]
        
        uploadStatusLabel.text = "Reddy to Upload"
        updateProgresBar(numberOfUploadedFile: 0)
        
        super.viewDidLoad()
        
        
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
             
        notificationCenter.addObserver(self, selector: #selector(appCameToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)

        // Do any additional setup after loading the view.
    }
    

    
    
    func updateProgresBar (numberOfUploadedFile : Int) {
        runOnMainQueue {
            let progressValue = Float(numberOfUploadedFile) /  Float(self.g_UploadFileDetails.totalNumberOfChuncks!)
            self.uploadPresentLabel.text = String(format: "%.2f %%", progressValue*100)
            self.uploadProgressBar.setProgress(progressValue, animated: true)
        }
    }
    
    
    @objc func appMovedToBackground() {
       print("app enters background")
        UserDefaltClass().setUploadFileDetails(UploadFileDetails: g_UploadFileDetails)
   }

   @objc func appCameToForeground() {
       print("app enters foreground")
       let UploadFileDetails = UserDefaltClass().getUploadFileDetails()
       if(UploadFileDetails != nil ) {
           g_UploadFileDetails = UploadFileDetails!
       }
   }
    
    @IBAction func backBtnPress(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func uploadFileBtnPress(_ sender: Any) {
        uploadStatusLabel.text = "Upload started"
        callCreateMultipartUpload(uploadFileDetails: g_UploadFileDetails)
    }
    
    
    func callCreateMultipartUpload(uploadFileDetails: StructUploadFileDetails) {
        
        //alamofire
//        APICreateMultipartUploadAlamofire(uploadFileDetails: uploadFileDetails) { (responceCreateMultipartUpload) in
//            //set respoce in globle variable
//            self.g_UploadFileDetails.ResCreateMultipartUpload = responceCreateMultipartUpload
//            //call Multi part per signed URL
//            self.callGetMultipartPreSignedUrl(uploadFileDetails: self.g_UploadFileDetails)
//    }
    
        
        //-------------------------------------
        //webSerive
        APIHander().APICreateMultipartUpload(uploadFileDetails: uploadFileDetails) { (responceCreateMultipartUpload) in
        //set respoce in globle variable
        self.g_UploadFileDetails.ResCreateMultipartUpload = responceCreateMultipartUpload
        //call Multi part per signed URL
            self.callGetMultipartPreSignedUrl(uploadFileDetails: self.g_UploadFileDetails)
        }
    }
    
    func callGetMultipartPreSignedUrl(uploadFileDetails : StructUploadFileDetails) {
        
//        //alamofire
//        APIGetMultipartPreSignedUrlAlamofire(uploadFileDetails: uploadFileDetails) {
//            (responceMultipartPreSignedUrl) in
//
//            self.g_UploadFileDetails.MultiPartPreSignedUrlArray = responceMultipartPreSignedUrl
//            self.callUploadPUTAPI(uploadFileDetails: self.g_UploadFileDetails)
//        }
        
        //-------------------------------------
        //webSerive
        APIHander().APIGetMultipartPreSignedUrl(uploadFileDetails: uploadFileDetails) {
            (responceMultipartPreSignedUrl) in
            
            self.g_UploadFileDetails.MultiPartPreSignedUrlArray = responceMultipartPreSignedUrl
            self.callUploadPUTAPI(uploadFileDetails: self.g_UploadFileDetails)
        }
    }
    
    func callUploadPUTAPI (uploadFileDetails: StructUploadFileDetails) {
        
        print("end callUploadPUTAPI")
        let group = DispatchGroup()
        var uploadCount = 0
        updateProgresBar(numberOfUploadedFile: uploadCount)
        
        //alamofire
        
        for j in 0...uploadFileDetails.chunkFileURLArray.count-1 {
            
//
//            group.enter()
//            APIUploadAlamofire(uploadFileDetails: uploadFileDetails, index: j) { responceUploadedFile in
//
//            self.UploadPUTAPIResponceHandler(responceUploadedFile: responceUploadedFile, uploadCount: &uploadCount, group: group, uploadFileDetails: uploadFileDetails)
//            }
//        }
        
        
        //-------------------------------------
        //webSerive
            
            group.enter()
            
            print(" callUploadPUTAPI  for loop")
            APIHander().APIUpload (uploadFileDetails: uploadFileDetails, index: j) { responceUploadedFile in
                runOnMainQueue {
                    self.uploadStatusLabel.text = "files Uploading... to server"
                }
                self.UploadPUTAPIResponceHandler(responceUploadedFile: responceUploadedFile, uploadCount: &uploadCount, group: group, uploadFileDetails: uploadFileDetails)
            }
        }
        
        group.notify(queue: .main) {
            self.uploadStatusLabel.text = "all files Upload to server"
            print("All uploads completed")
            self.callCompleteMultipartUpload(uploadFileDetails: self.g_UploadFileDetails)
        }
    }
    
    func callCompleteMultipartUpload (uploadFileDetails: StructUploadFileDetails) {
        
        print(" callCompleteMultipartUpload")
//        //alamofire
//        APICompleteMultipartUploadAlamofire(uploadFileDetails: uploadFileDetails) { responceCompleteMultipartUpload in
//            print(responceCompleteMultipartUpload)
//        }
        
        //-------------------------------------
        //webSerive
        APIHander().APICompleteMultipartUpload(uploadFileDetails: uploadFileDetails) { responceCompleteMultipartUpload in
            print(responceCompleteMultipartUpload)
        }
        print("end callCompleteMultipartUpload")
    }
    
    
    
    
    func UploadPUTAPIResponceHandler (responceUploadedFile: StructAPIResUploadedFile, uploadCount : inout Int ,group : DispatchGroup , uploadFileDetails: StructUploadFileDetails) {
    
        
        uploadCount = uploadCount+1
        self.updateProgresBar(numberOfUploadedFile: uploadCount)
        
        let responceURL = responceUploadedFile.ResponceURL
        print("-------------------+++++++--------------------")
        
        for i in 0...uploadFileDetails.chunkFileURLArray.count-1 {
            
            let url1: StructPreSigned = uploadFileDetails.MultiPartPreSignedUrlArray!.parts[i]
            let preSignedUrl = url1.signedUrl
            
            if preSignedUrl == responceURL.absoluteString {
                // Your code here
                print("preSignedUrl ---",preSignedUrl)
                print("URLs are equal",responceUploadedFile.Etag)
                
                self.g_UploadFileDetails.ETagArray[i] = responceUploadedFile.Etag
                
            } else {
                //print("URLs are not equal")
            }
        }
        group.leave()
    }
    

}
