//
//  FeedVC.swift
//  Firebase Social Media
//
//  Created by Will Fuger on 10/13/16.
//  Copyright © 2016 BoogieSquad. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageToAdd: CircleImage!
    @IBOutlet weak var captionTextField: CustomTextField!
    
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var imageSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        
        
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            self.posts.removeAll()
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    print("WILL: SNAP: \(snap)")
                    if let postDict = snap.value as? [String: AnyObject] {
                        print("DATAAA \(postDict)")
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
                self.tableView.reloadData()
            } else {
                print("WILL: Error in Firebase get")
            }
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        print("WILL: likes from feed vc \(post.likes)")
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            
            if let img = FeedVC.imageCache.object(forKey: post.imageUrl as NSString) {
                cell.configureCell(post: post, img: img)
            } else {
                cell.configureCell(post: post)
            }
            return cell
        } else {
            return PostCell()
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageToAdd.image = image
            imageSelected = true
        } else {
            print("WILL: A valid image wasn't selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    @IBAction func postBtnPressed(_ sender: AnyObject) {
        
        guard let caption = captionTextField.text, caption != ""  else {
            print("WILL: Caption must be entered")
            return
        }
        guard let img = imageToAdd.image, self.imageSelected == true else {
            print("WILL: An image must be selected")
            return
        }
        
        if let imgData = UIImageJPEGRepresentation(img, 0.2) {
            
            let imgUID = UUID().uuidString
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            
            DataService.ds.REF_POST_PICS.child(imgUID).put(imgData, metadata: metadata, completion: { (metadata, error) in
                if let error = error {
                    print("WILL: Unable to upload image to Firebase storage \(error)")
                } else {
                    print("WILL: Successfully uploaded image to Firebase storage")
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                    if let url = downloadURL {
                        self.postToFirebase(imgUrl: url)
                    }
                }
            })
        }
    }
    
    func postToFirebase(imgUrl: String) {
        let post: [String: Any] = [
            "caption": captionTextField.text!,
            "imageUrl": imgUrl,
            "likes": 0
        ]
        
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        captionTextField.text = nil
        imageToAdd.image = UIImage(named: "add-image")
        imageSelected = false
        tableView.reloadData()
    }
    
    @IBAction func signOutPressed(_ sender: AnyObject) {
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("WILL: Removed user id from keychain \(keychainResult)")
        try! FIRAuth.auth()?.signOut()
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func addImagePressed(_ sender: AnyObject) {
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    
}
