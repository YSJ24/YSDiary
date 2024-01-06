//
//  DiaryTableViewCell.swift
//  Diary
//
//  Created by Yeseul Jang on 2023/08/29.
//

import UIKit

final class DiaryTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        createdDateLabel.text = nil
        bodyLabel.text = nil
    }
    
    func configureLabel(item: Item) {
        let formattedSampleDate = CustomDateFormatter.formatTodayDate() // 수정해야함

        createdDateLabel.text = formattedSampleDate
        titleLabel.text = item.itemTitle
        bodyLabel.text = item.itemBody
    }
}
