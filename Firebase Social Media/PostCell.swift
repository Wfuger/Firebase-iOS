//
//  PostCell.swift
//  Firebase Social Media
//
//  Created by Will Fuger on 10/13/16.
//  Copyright © 2016 BoogieSquad. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likesLbl: UILabel!

    var post: Post!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(post: Post) {
        self.post = post
        self.caption.text = post.caption
        self.likesLbl.text = String(post.likes)
        
        print("WILL: Image URL from Firebase \(post.imageUrl)")
        if let url = URL(string: post.imageUrl) {
            if let imageData = try? Data(contentsOf: url) {
                print("WILL: GOT Inside the image data")
                let img = UIImage(data: imageData)
                self.postImg.image = img
            }
        }
        
    }
    

}
