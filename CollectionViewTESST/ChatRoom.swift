//
//  ChatRoom.swift
//  CollectionViewTESST
//
//  Created by Frank Joseph Boccia on 3/9/17.
//  Copyright © 2017 Frank Joseph Boccia. All rights reserved.
//

import Foundation
import UIKit

class ChatRoom: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    
    @IBOutlet weak var collectionView2: UICollectionView!
    
    
    
    var secondClass : ChatCell?
    
    struct Object {
        var image: UIImage!
        var title: String!
    }
    
    // Properties
    var object: Object?
    var objects: [Object] = []
    var picker: UIImagePickerController!
    
    
    // Do any additional setup after loading the view, typically from a nib.
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker = UIImagePickerController()
        picker?.allowsEditing = false
        picker?.delegate = self
        picker?.sourceType = .photoLibrary
        // CollectionView
        collectionView2.delegate = self
        collectionView2.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.isTranslucent = false
        // self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.green
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(didSelectCreateButton))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.green
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        let object = objects[indexPath.row]
        
        secondClass?.chatLabel.text = object.title ?? ""
        secondClass?.chatImage.image = object.image ?? UIImage()
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return objects.count
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        switch info[UIImagePickerControllerOriginalImage] as? UIImage {
        case let .some(image):
            object?.image = image
        default:
            break
        }
        
        picker.dismiss(animated: true) {
            self.showCellTitleAlert()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        object = nil
        
        dismiss(animated: true) {
            self.collectionView2!.reloadData()
        }
    }
    
    // Alerts
    func showCellTitleAlert() {
        
        let alert = UIAlertController(title: "Cell Title", message: nil, preferredStyle: .alert)
        
        alert.addTextField { $0.placeholder = "Title" }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.object = nil
        })
        alert.addAction(UIAlertAction(title: "Save", style: .default) { _ in
            self.object?.title = (alert.textFields?.first.flatMap { $0.text })!
            self.object.flatMap { self.objects.append($0) }
            self.collectionView2?.reloadData()
        })
        
        present(alert, animated: true, completion: nil)
    }
    
    // Create new Cell
    @IBAction func didSelectCreateButton() {
        
        object = Object()
        
        present(picker, animated: true, completion: nil)
    }
    
}
