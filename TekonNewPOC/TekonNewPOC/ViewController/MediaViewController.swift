//
//  MediaViewController.swift
//  TekonNewPOC
//
//  Created by Muhammed Ayaz on 17/11/23.
//

import UIKit

class MediaViewController: BaseViewController {

    @IBOutlet weak var uploadPresentLabel: UILabel!
    @IBOutlet weak var uploadStatusLabel: UILabel!
    @IBOutlet weak var uploadProgressBar: UIProgressView!
    
    
    //declar Globale vaibale for access in all over
    var g_UploadFileDetails : StructUploadFileDetails = StructUploadFileDetails()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uploadStatusLabel.text = "Reddy to Upload"
        
        let fileName = "test.mp4"
        //Get file Info
        let fileInfoObj : StructFileInfo = getFileDetails(fileName: fileName)
        //Split Video In chunks
        splitVideoInto5MBChunks(fileInfo: fileInfoObj)
        //Fill Goble Varibale
        g_UploadFileDetails = getUploadFileDetails(fileInfoObj: fileInfoObj)
        
        updateProgresBar(numberOfUploadedFile: 0)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(appCameToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        
    }
    
    
    @objc func appMovedToBackground() {
       print("app enters background")
        UserDefaltClass().setUploadFileDetails(UploadFileDetails: g_UploadFileDetails)
   }

   @objc func appCameToForeground() {
       print("app enters foreground")
       var UploadFileDetails = UserDefaltClass().getUploadFileDetails()
   }
    
    @IBAction func openGallaryBtnPress(_ sender: Any) {
        AttachmentHandler.shared.showAttachmentActionSheet(vc: self)
        AttachmentHandler.shared.imagePickedBlock = { (image) in
            print("image here i am")
        /* get your image here */
        }
        AttachmentHandler.shared.videoPickedBlock = { (videourl) in
            print("videoURL here i am")
            do {
                let data = try Data(contentsOf: videourl)
                let outputFileName = "test.mp4"
                let outputURL = getDocumentDirectoriesPathURL().appendingPathComponent(outputFileName)
                try data.write(to: outputURL)
            } catch {
                print("Error: \(error)")
            }
        }
        print("DocumentDirectoriesPath", getDocumentDirectoriesPath())
    }
    
    @IBAction func uploadFileBtnPress(_ sender: Any) {
        uploadStatusLabel.text = "Upload started"
        callCreateMultipartUpload(uploadFileDetails: g_UploadFileDetails)
    }
    
    
    func updateProgresBar (numberOfUploadedFile : Int) {
       
        runOnMainQueue {
            let progressValue = Float(numberOfUploadedFile) /  Float(self.g_UploadFileDetails.totalNumberOfChuncks!)
            self.uploadPresentLabel.text = String(format: "%.2f %%", progressValue*100)
            self.uploadProgressBar.setProgress(progressValue, animated: true)
        }
    }
    
    
    func getFileDetails(fileName : String) ->  StructFileInfo {
        let fileURL = getDocumentDirectoriesPathURL().appendingPathComponent(fileName)
        let filePath = getDocumentDirectoriesPath().appendSlash.appending(fileName)
        let fileExtention = getFileExtensionFromURL(fileURL: fileURL)
        let fileNameWithoutExt = getFileNameWithoutExtension(fileURL: fileURL)
        
        let fileInfo = StructFileInfo(fileName: fileName, filePath: filePath, fileExtention: fileExtention, fileURL: fileURL, fileNameWithoutExt: fileNameWithoutExt)
        return fileInfo
    }
    
    func getUploadFileDetails(fileInfoObj : StructFileInfo) ->  StructUploadFileDetails {
        
        let fileManager = FileManager.default
        let folderPath = getDocumentDirectoriesPathURL().appendingPathComponent(fileInfoObj.fileNameWithoutExt)
        let chunkFileURLArray = try! fileManager.contentsOfDirectory(at: folderPath, includingPropertiesForKeys: nil).sorted { $0.path < $1.path }
        
        var chunkFilePathArray = [String]()
        for url in chunkFileURLArray {
            //chunkFilePathArray.append(try! String(contentsOf: url))
            chunkFilePathArray.append(url.path)
        }
        
        var ETagArray = [String]()
        for _ in 1...chunkFileURLArray.count {
            
            ETagArray.append("")
        }
        
        let uploadFileDetailsObj = StructUploadFileDetails(fileInfo: fileInfoObj, chunkFilePathArray: chunkFilePathArray, chunkFileURLArray: chunkFileURLArray, totalNumberOfChuncks: chunkFileURLArray.count, ETagArray: ETagArray)
        
        return uploadFileDetailsObj
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
