//
//  ViewController.swift
//  samplepro
//
//  Created by aneena on 28/08/18.
//  Copyright © 2018 aneena. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FacebookLogin

class ViewController: UIViewController,GIDSignInUIDelegate,GIDSignInDelegate {

    @IBOutlet weak var fbLogin: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var signinButton: UIButton!
    var dict : [String : AnyObject]!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        GIDSignIn.sharedInstance().uiDelegate = self
        nameLabel.isHidden = true
        //creating button
//
//        //adding it to view
//        view.addSubview(loginButton)
        let loginButton = LoginButton(readPermissions: [ .publicProfile ])
        //if the user is already logged in
        if (FBSDKAccessToken.current()) != nil{
            getFBUserData()
        }


fbLogin.addSubview(loginButton)
    }
    @IBAction func fbSignin(_ sender: Any) {
self.loginButtonClicked()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func signinButton(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
                GIDSignIn.sharedInstance().delegate = self

    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
            // [START_EXCLUDE silent]
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: "ToggleAuthUINotification"), object: nil, userInfo: nil)
            // [END_EXCLUDE]
        } else {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            // [START_EXCLUDE]
            print("user",fullName ?? "")
            signinButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
            signinButton.titleLabel?.text = "Signed in as"
            nameLabel.isHidden = false
            nameLabel.text = fullName
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: "ToggleAuthUINotification"),
                object: nil,
                userInfo: ["statusText": "Signed in user:\n\(fullName)"])
            // [END_EXCLUDE]
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // [START_EXCLUDE]
        NotificationCenter.default.post(
            name: Notification.Name(rawValue: "ToggleAuthUINotification"),
            object: nil,
            userInfo: ["statusText": "User has disconnected."])
        // [END_EXCLUDE]
    }
    @objc func loginButtonClicked() {
        let loginManager=LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile], viewController : self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Logged in")
            }
        }
        
    }
        
        //function is fetching the user data
        func getFBUserData(){
            if((FBSDKAccessToken.current()) != nil){
                FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                    if (error == nil){
                        self.dict = result as! [String : AnyObject]
                        print(result!)
                        print(self.dict)
                    }
                })
            }
        }
}


