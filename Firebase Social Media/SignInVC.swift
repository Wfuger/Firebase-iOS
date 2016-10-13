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
import SwiftKeychainWrapper

class SignInVC: UIViewController {
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
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
                if let user = user {
                    self.completeSignIn(id: user.uid)
                }
            }
        })
    }
    @IBAction func signInPressed(_ sender: AnyObject) {
        
        if let email = emailTextField.text, let pwd = passwordTextField.text {
          FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
            if error == nil {
                print("WILL: Email user authenticated with Firebase")
                if let user = user {
                    self.completeSignIn(id: user.uid)
                }
            } else {
                FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                    if let error = error {
                        print("WILL: Unable to authenticate Email user with Firebase - \(error)")
                    } else {
                        print("WILL: Successfully authenticated Email user with Firebase")
                        if let user = user {
                            self.completeSignIn(id: user.uid)
                        }
                    }
                })
            }
          })
        }
        
    }

    func completeSignIn(id: String) {
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("WILL: Data saved to keychain \(keychainResult)")
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }
}

