//
//  MediaListTableViewCell.swift
//  TekonNewPOC
//
//  Created by Muhammed Ayaz on 29/11/23.
//

import UIKit

class MediaListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var thumImageView: UIImageView!
    @IBOutlet weak var fileNameLabel: UILabel!
    @IBOutlet weak var fileSizeLabel: UILabel!
    @IBOutlet weak var uploadBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
