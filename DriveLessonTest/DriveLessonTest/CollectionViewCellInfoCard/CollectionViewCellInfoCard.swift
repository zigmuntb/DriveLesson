//
//  CollectionViewCellInfoCard.swift
//  DriveLessonTest
//
//  Created by Arsenkin Bogdan on 7/12/19.
//  Copyright © 2019 Arsenkin Bogdan. All rights reserved.
//

import UIKit

class CollectionViewCellInfoCard: UICollectionViewCell {
	
	var dataModel = DataModel()
	
	@IBOutlet weak var view: UIView!
	@IBOutlet weak var cardImageView: UIImageView!
	@IBOutlet weak var likeButton: UIButton!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var reviewsScoreLabel: UILabel!
	@IBOutlet weak var locationLabel: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		view.layer.cornerRadius = 8
		view.layer.masksToBounds = true
		view.layer.borderWidth = 1
		view.layer.borderColor = UIColor(red: 216.0 / 255.0, green: 216.0 / 255.0, blue: 216.0 / 255.0, alpha: 1).cgColor
	}
	
}
