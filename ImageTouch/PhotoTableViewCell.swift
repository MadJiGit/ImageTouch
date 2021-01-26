//
//  PhotoTableViewCell.swift
//  ImageTouch
//
//  Created by Madji on 26.01.21.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var photoImageCell: UIImageView!
    @IBOutlet weak var photoLabelCell: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
