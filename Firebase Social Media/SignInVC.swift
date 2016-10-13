//
//  ViewController.swift
//  Firebase Social Media
//
//  Created by Will Fuger on 10/12/16.
//  Copyright © 2016 BoogieSquad. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class SignInVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func facebookBtnPressed(_ sender: AnyObject) {
        
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if let error = error {
                print("WILL: Unable to authenticate with Facebook - \(error)")
            } else if result?.isCancelled == true {
                print("WILL: User cancelled Facebook authentication")
            } else {
                print("WILL: Successfully authenticated with Facebook\n")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if let error = error {
                print("WILL: Unable to authenticate with Firebase - \(error)")
            } else {
                print("WILL: Successfully authenticated with Firebase")
            }
        })
    }

}

