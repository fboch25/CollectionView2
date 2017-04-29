//
//  ChatRoom.swift
//  CollectionViewTESST
//
//  Created by Frank Joseph Boccia on 3/9/17.
//  Copyright © 2017 Frank Joseph Boccia. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ChatRoom: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {

    // Struct of Objects
    struct Object {
        var image: UIImage!
        var title: String!
    }
    
    // Properties
    var object: Object?
    var objects: [Object] = []
    var picker: UIImagePickerController!
     var ref: FIRDatabaseReference?
  
    @IBOutlet weak var collectionView2: UICollectionView!
    // Instance of a class
    var secondClass : ChatCell?
    
    
    // Do any additional setup after loading the view, typically from a nib.
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // User Logged In
        checkIfUserLoggedIn()
        // Firebase Data 
         ref = FIRDatabase.database().reference()
        
        picker = UIImagePickerController()
        picker?.allowsEditing = false
        picker?.delegate = self
        picker?.sourceType = .photoLibrary
        // CollectionView
        collectionView2?.delegate = self
        collectionView2?.dataSource = self
        collectionView2?.reloadData()
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ChatCell
        let object = objects[indexPath.row]
        
            cell.chatLabel.text = object.title ?? ""
            cell.chatImage.image = object.image ?? UIImage()
            cell.layer.borderWidth = 2
            cell.layer.borderColor = UIColor.white.cgColor
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 6
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return objects.count
        
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = collectionView2.bounds.width
        let itemHeight = collectionView2.bounds.height
        return CGSize(width: itemWidth, height: itemHeight)
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
        
        alert.addTextField { $0.placeholder = "Enter only 10 characters" }
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
    
    // User Logged In
    private func checkIfUserLoggedIn() {
        if FIRAuth.auth()?.currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
            
        } else {
            
            let uid =  FIRAuth.auth()?.currentUser?.uid
            FIRDatabase.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictonary = snapshot.value as? [String: AnyObject] {
                    self.navigationItem.title = (dictonary["name"] as? String)
                }
                
            }, withCancel: nil )
        }
    }
    
    func handleLogout() {
        
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
        let loginController = LoginViewController()
        present(loginController, animated: true, completion: nil)
        print("User logged out")
    }
}

