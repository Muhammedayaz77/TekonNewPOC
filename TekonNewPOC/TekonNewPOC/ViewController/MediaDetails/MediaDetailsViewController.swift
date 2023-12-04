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
    @IBOutlet weak var logTextView: UITextView!
    //declar Globale vaibale for access in all over
    var g_UploadFileDetails : StructUploadFileDetails = StructUploadFileDetails()
    
    
    
    override func viewDidLoad() {
        
        g_UploadFileDetails = g_UploadFileDetailsArray[g_selectedFileIndex]
        
        uploadStatusLabel.text = g_UploadFileDetails.uploadStatus?.rawValue
        updateProgresBar(numberOfUploadedFile: getUploadCount())
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func updateProgresBar (numberOfUploadedFile : Int) {
        runOnMainQueue {
            let progressValue = Float(numberOfUploadedFile) /  Float(self.g_UploadFileDetails.totalNumberOfChuncks!)
            self.uploadPresentLabel.text = String(format: "%.2f %%", progressValue*100)
            self.uploadProgressBar.setProgress(progressValue, animated: true)
            
            self.PrintLog(logStr: "\n")
        }
    }
    
    
    func getUploadCount () -> Int {
        var uploadCount = 0
        for i in 0...g_UploadFileDetails.ETagArray.count-1 {
            if g_UploadFileDetails.ETagArray[i] != "" {
                print("not empty");
                uploadCount = uploadCount+1
            }
        }
        return uploadCount
    }
    
   
    
    @IBAction func backBtnPress(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func uploadFileBtnPress(_ sender: Any) {
        
        g_UploadFileDetails.uploadStatus = enumUploadStatus.Uploding
        g_UploadFileDetailsArray[g_selectedFileIndex].uploadStatus = enumUploadStatus.Uploding
        
        uploadStatusLabel.text = g_UploadFileDetails.uploadStatus?.rawValue
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
        g_UploadFileDetailsArray[g_selectedFileIndex].ResCreateMultipartUpload = responceCreateMultipartUpload
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
            g_UploadFileDetailsArray[g_selectedFileIndex].MultiPartPreSignedUrlArray = responceMultipartPreSignedUrl
            
            
            self.callUploadPUTAPI(uploadFileDetails: self.g_UploadFileDetails)
        }
    }
    
    func callUploadPUTAPI (uploadFileDetails: StructUploadFileDetails) {
        
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
            
            APIHander().APIUpload (uploadFileDetails: uploadFileDetails, index: j) { responceUploadedFile in
                runOnMainQueue {
                    self.uploadStatusLabel.text = "files Uploading... to server"
                }
                self.UploadPUTAPIResponceHandler(responceUploadedFile: responceUploadedFile, uploadCount: &uploadCount, group: group, uploadFileDetails: uploadFileDetails)
            }
        }
        
        group.notify(queue: .main) {
            
            
            self.g_UploadFileDetails.uploadStatus = enumUploadStatus.UploadComplete
            g_UploadFileDetailsArray[g_selectedFileIndex].uploadStatus = enumUploadStatus.UploadComplete
            
            self.uploadStatusLabel.text = self.g_UploadFileDetails.uploadStatus?.rawValue
            self.PrintLog(logStr: "All uploads completed")
            self.callCompleteMultipartUpload(uploadFileDetails: self.g_UploadFileDetails)
        }
    }
    
    func callCompleteMultipartUpload (uploadFileDetails: StructUploadFileDetails) {
        
//        //alamofire
//        APICompleteMultipartUploadAlamofire(uploadFileDetails: uploadFileDetails) { responceCompleteMultipartUpload in
//            print(responceCompleteMultipartUpload)
//        }
        
        //-------------------------------------
        //webSerive
        APIHander().APICompleteMultipartUpload(uploadFileDetails: uploadFileDetails) { responceCompleteMultipartUpload in
            print(responceCompleteMultipartUpload)
        }
    }
    
    
    
    
    func UploadPUTAPIResponceHandler (responceUploadedFile: StructAPIResUploadedFile, uploadCount : inout Int ,group : DispatchGroup , uploadFileDetails: StructUploadFileDetails) {
    
        
        
        let responceURL = responceUploadedFile.ResponceURL
        PrintLog(logStr: "-------------------+++++++--------------------")
        
        
        for i in 0...uploadFileDetails.chunkFileURLArray.count-1 {
            
            let url1: StructPreSigned = uploadFileDetails.MultiPartPreSignedUrlArray!.parts[i]
            let preSignedUrl = url1.signedUrl
            
            if preSignedUrl == responceURL.absoluteString {
                // Your code here
                print("preSignedUrl ---",preSignedUrl)
                PrintLog(logStr: "URLs are equal")
                PrintLog(logStr: responceUploadedFile.Etag)
                
                self.g_UploadFileDetails.ETagArray[i] = responceUploadedFile.Etag
                g_UploadFileDetailsArray[g_selectedFileIndex].ETagArray[i] = responceUploadedFile.Etag
                
                self.updateProgresBar(numberOfUploadedFile: getUploadCount())
                
            } else {
                //print("URLs are not equal")
            }
        }
        group.leave()
    }
    
    
    func PrintLog(logStr : String) {
        runOnMainQueue {
            print(logStr)
            
            g_LogString.append("\n"+logStr)
            self.logTextView.text = g_LogString
        }
    }
}
