//
//  aTableViewCell.swift
//  TekonNewPOC
//
//  Created by Muhammed Ayaz on 29/11/23.
//

import UIKit

class aTableViewCell: UITableViewCell {

    @IBOutlet weak var uploadPresentLabel: UILabel!
    @IBOutlet weak var uploadProgressBar: UIProgressView!
    @IBOutlet weak var uploadFileBtn: UIButton!
    @IBOutlet weak var openGallaryBtn: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
