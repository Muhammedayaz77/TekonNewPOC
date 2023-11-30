//
//  MediaListViewController.swift
//  TekonNewPOC
//
//  Created by Muhammed Ayaz on 29/11/23.
//

import UIKit
import Alamofire

class MediaListViewController: BaseViewController {

    
    @IBOutlet weak var mediaListTableView: UITableView!
    
    var g_VideoThumArray = [UIImage]()

    
    override func viewDidLoad() {
        
        print("DocumentDirectoriesPath", getDocumentDirectoriesPath())
        
        initializeCellWithIdentifier(aTableView: mediaListTableView, nibName: "MediaListTableViewCell", cellIdentifier: "mediaListCellId")
        mediaListTableView.dataSource = self
        mediaListTableView.delegate = self
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
    
    @IBAction func selectVideoBtnPress(_ sender: Any) {
        if g_UploadFileDetailsArray.count < 10 {
            openGellary(index: g_UploadFileDetailsArray.count)
        } else {
            showAlert(withTitle: "max limit", withMessage: "You can select maximum 10 files only")
        }
        
    }
    
    @objc func openGellaryBtnPress (_ sender: Any) {
        openGellary(index: (sender as AnyObject).tag)
    }
    
    
    func openGellary (index :Int) {
        
        AttachmentHandler.shared.showAttachmentActionSheet(vc: self)
        
        AttachmentHandler.shared.videoPickedBlock = { (videourl) in
            print("videoURL here i am")
            var fileNameWithoutExt = "test.mp4"
            do {
               // fileNameStr = getFileNameFromURL(fileURL: videourl)
                fileNameWithoutExt = getFileNameWithoutExtension(fileURL: videourl)
                
                fileNameWithoutExt =   fileNameWithoutExt.appending(".mp4")
                let data = try Data(contentsOf: videourl)
                saveFileInDocument(fileData: data, fileName: fileNameWithoutExt)
                if index < self.g_VideoThumArray.count {
                    self.g_VideoThumArray[index] = createThumbnailOfVideo(url: videourl)!
                } else {
                    self.g_VideoThumArray.append(createThumbnailOfVideo(url: videourl)!)
                }
                
            } catch {
                print("Error: \(error)")
                self.showAlert(withTitle: "Error in File", withMessage: error.localizedDescription)
            }
    
            self.setBasicObj(fileName: fileNameWithoutExt, index: index)
            self.mediaListTableView.reloadData()
        }
    }
    
    
    
    func setBasicObj(fileName :String, index :Int ) {
        //Get file Info
        let fileInfoObj : StructFileInfo = getFileDetails(fileName: fileName)
        //Split Video In chunks
        splitVideoInto5MBChunks(fileInfo: fileInfoObj)
        //Fill Goble Array
        if index < g_UploadFileDetailsArray.count {
            g_UploadFileDetailsArray[index] = getUploadFileDetails(fileInfoObj: fileInfoObj)
        } else {
            g_UploadFileDetailsArray.append(getUploadFileDetails(fileInfoObj: fileInfoObj))
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
    
    func switchToMediaDeatilsScreen( index: Int) {
        g_selectedFileIndex = index
        
        print("g_UploadFileDetailsArray",g_UploadFileDetailsArray)
        // Register Nib
        let viewController = MediaDetailsViewController(nibName: "MediaDetailsViewController", bundle: nil)
        viewController.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        self.present(viewController, animated: false, completion: nil)
    }
    
    

}



extension MediaListViewController : UITableViewDelegate, UITableViewDataSource {
    
    
    //MARK: - TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        // If you're serving data from an array, return the length of the array:
        return g_UploadFileDetailsArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    // Customize the appearance of table view cells.
    
    
    
    //MARK: - cell For Row At indexPath
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "mediaListCellId", for: indexPath) as! MediaListTableViewCell
        
        let UploadFileDetails = g_UploadFileDetailsArray[indexPath.row]
        let fileInfo = UploadFileDetails.fileInfo
        
        
        cell.fileNameLabel.text = fileInfo?.fileName
        cell.fileSizeLabel.text = "\(String(describing: UploadFileDetails.totalNumberOfChuncks!)) chunk"
        cell.thumImageView.image = g_VideoThumArray[indexPath.row]
        
        cell.uploadBtn.tag = indexPath.row
        
        cell.uploadBtn.addTarget(self,action:#selector(openGellaryBtnPress), for:.touchUpInside)
        
        return cell
    }
    
    //MARK: - did Select Row At indexPath
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        switchToMediaDeatilsScreen(index: indexPath.row)
   
        
    }
    
}
