//
//  CollectionViewController.swift
//  PhoneBook
//
//  Created by Cote, Louis-David on 2017-02-21.
//  Copyright © 2017 Cote, Louis-David. All rights reserved.
//

import UIKit

private let reuseIdentifier = "imageCell"

class CollectionViewController: UICollectionViewController {
    var theImageListMale = ["1", "3", "7", "8", "10", "13"]
    var theImageListFemale = ["2", "4", "5", "6", "9", "11", "12", "14", "15", "16", "17", "18"]
    var theImageListOther = [String]()
    var theImageListInUse = [String]()
    var theIndexOfImage:Int!
    var objToSaveTo:ImageStringSavable!

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView?.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        theImageListOther.append(contentsOf: theImageListMale)
        theImageListOther.append(contentsOf: theImageListFemale)
        
        
        theImageListInUse.append("")
        switch theIndexOfImage {
            case 1: theImageListInUse.append(contentsOf: theImageListMale)
            case 2: theImageListInUse.append(contentsOf: theImageListFemale)
            default: theImageListInUse.append(contentsOf: theImageListOther)
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

//DataSource Methods
extension CollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.objToSaveTo.SaveAnImageString(theImageString: "")
        } else {
            self.objToSaveTo.SaveAnImageString(theImageString: self.theImageListInUse[indexPath.row])
        }
        dismiss(animated: true, completion: nil)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return theImageListInUse.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
        
        if let theImage = UIImage(named: theImageListInUse[indexPath.row]) {
            cell.theImageView.image = theImage
        } else {
            cell.backgroundColor = UIColor.lightGray
        }

        return cell
    }
}
