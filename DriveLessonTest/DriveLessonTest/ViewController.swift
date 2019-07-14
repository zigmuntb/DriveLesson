//
//  ViewController.swift
//  DriveLessonTest
//
//  Created by Arsenkin Bogdan on 7/12/19.
//  Copyright © 2019 Arsenkin Bogdan. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SDWebImage

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

	var dataArray = [DataModel]()
	let DATA_URL = "https://api.github.com/users?since=0&per_page=80"
	let numberOfCards = 4
	var nextIndex = 0
	
	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var loadingView: LoadingView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		collectionView.delegate = self
		collectionView.dataSource = self
		
		collectionView.register(UINib(nibName: "CollectionViewCellInfoCard", bundle: nil), forCellWithReuseIdentifier: String(describing: CollectionViewCellInfoCard.self))
//		InstructorButton.layer.cornerRadius = 5
//		InstructorButton.layer.borderWidth = 1
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		getData(url: DATA_URL, index: nextIndex, numberOfCards: numberOfCards)
		nextIndex += numberOfCards
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return dataArray.count
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		print("You tapped on \(indexPath.row) cell")
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CollectionViewCellInfoCard.self), for: indexPath) as! CollectionViewCellInfoCard
		let url = URL(string: dataArray[indexPath.row].avatar_url)
		
		cell.cardImageView.sd_setImage(with: url, completed: nil)
		cell.nameLabel.text = dataArray[indexPath.row].login
		cell.reviewsScoreLabel.text = String(dataArray[indexPath.row].id)
		cell.locationLabel.text = dataArray[indexPath.row].type + " - Show on map"
		
		if dataArray[indexPath.row].site_admin {
			cell.likeButton.setImage(UIImage(named: "icons8-like-1"), for: .normal)
		} else {
			cell.likeButton.setImage(UIImage(named: "icons8-like"), for: .normal)
		}
		
		if indexPath.row == dataArray.count - 1 {
			DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
				self.getData(url: self.DATA_URL, index: self.nextIndex, numberOfCards: self.numberOfCards)
				self.nextIndex += 4
			}
		}
		
		return cell
	}
	
	// frame.width / 2 - 8
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		
		return CGSize(width: view.bounds.width / 2 - 16, height: 300)
	}
	
	
	
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "collectionViewCellHeader", for: indexPath)
		return headerView
	}
	
	func getData(url: String, index: Int, numberOfCards: Int) {
		loadingView.show()
		Alamofire.request(url, method: .get).responseJSON {
			responce in
			
			if responce.result.isSuccess {
				print("Success! Got the data!")
				let dataJSON: JSON = JSON(responce.result.value!)
				self.updateData(json: dataJSON, cardIndex: index, numberOfCards: numberOfCards)
			}
			else {
				print("Error \(String(describing: responce.result.error))")
			}
			
			self.loadingView.hide()
		}
	}
	
	func updateData(json: JSON, cardIndex: Int, numberOfCards: Int) {
		
		guard let array = json.arrayObject as? [[String : Any]] else { return }
		
		for (index, object) in array.enumerated() {
			if index >= cardIndex && index < cardIndex + numberOfCards {

			let dataModel = DataModel()

			dataModel.avatar_url = object["avatar_url"] as? String ?? String()
			dataModel.login = object["login"] as? String ?? String()
			dataModel.id = object["id"] as? Int ?? Int()
			dataModel.type = object["type"] as? String ?? String()
			dataModel.site_admin = object["site_admin"] as? Bool ?? Bool()

			dataArray.append(dataModel)
			}
		}
		
		collectionView.reloadData()

	}
	
}

