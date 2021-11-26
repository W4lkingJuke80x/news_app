//
//  NewsCellTableViewCell.swift
//  News
//
//  Created by Dauren Omarov on 26.11.2021.
//

import UIKit

class NewsCell: UITableViewCell {
    
    @IBOutlet var thumbnailImage: UIImageView!
    @IBOutlet var newsLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
