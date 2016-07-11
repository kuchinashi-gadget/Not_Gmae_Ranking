//
//  Custom_1_TableViewCell.swift
//  Not_Game_Ranking
//


import UIKit


class Custom_1_TableViewCell: UITableViewCell {
    
    @IBOutlet weak var ranking_label: UILabel!
    @IBOutlet weak var app_icon_image: UIImageView!
    @IBOutlet weak var app_title_label: UILabel!
    @IBOutlet weak var app_category_title: UILabel!
    @IBOutlet weak var app_hyouka: UIImageView!
    @IBOutlet weak var app_kakaku_titile: UILabel!
    @IBOutlet weak var hyoukasu_label: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
