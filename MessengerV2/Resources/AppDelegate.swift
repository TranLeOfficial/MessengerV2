//
//  AppDelegate.swift
//  MessengerV2
//
//  Created by Trần Lễ on 10/3/21.
//

// Swift
//
// AppDelegate.swift
import UIKit
import FBSDKCoreKit
import Firebase
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        FirebaseApp.configure()
        
        //Facebook
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        
        //Google
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance()?.delegate = self

        return true
    }
          
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {

        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
        
        //Login with Google Signin
        return GIDSignIn.sharedInstance().handle(url)
    }
}
    

//MARK: - Login with Google
extension AppDelegate: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard error == nil else {
            if let err = error {
                print("Failed to signin with Google ", err)
            }
            return
        }
        
        guard let user = user else {
            return
        }
        print("Did signin with Google: ", user)
        
        guard let email = user.profile.email,
              let firstName = user.profile.givenName,
              let lastName = user.profile.familyName else {
            return
        }
        
        DatabaseManager.shared.userExists(with: email, completion: { exists in
            if !exists {
                //insert to database
//                DatabaseManager.shared.insertUser(with: ChatAppUser(emailAddress: email,
//                                                                    firstName: firstName,
//                                                                    lastName: lastName,
//                                                                    password: ""))
                let chatUser = ChatAppUser(emailAddress: email,
                                           firstName: firstName,
                                           lastName: lastName,
                                           password: "")
                DatabaseManager.shared.insertUser(with: chatUser) { sucess in
                    if sucess {
                        
                        if user.profile.hasImage {
                            guard let url = user.profile.imageURL(withDimension: 200) else {
                                return
                            }
                            
                            URLSession.shared.dataTask(with: url) { data, _, _ in
                                guard let data = data else {
                                    return
                                }
                                
                                //upload image
                                let fileName = chatUser.profilePictureFileName
                                StorageManager.shared.uploadProfilePicture(with: data,
                                                                           fileName: fileName) { result in
                                    switch result {
                                    case .success(let downloadUrl):
                                        UserDefaults.standard.set(downloadUrl, forKey: "profile_picture_url")
                                        print(downloadUrl)
                                    case .failure(let error):
                                        print("StorageManagerError ", error)
                                    }
                                }
                            }.resume()
                        }
                        
                        
                    }
                }
            }
        })
        
        guard let authentication = user.authentication, let idToken = authentication.idToken else {
            print("Missing Auth object off of google user")
            return
        }
        let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                       accessToken: authentication.accessToken)
        
        FirebaseAuth.Auth.auth().signIn(with: credential, completion: { authResult, error in
            guard authResult != nil, error == nil else {
                print("Failed to login with google credential _!")
                return
            }
            print("Google login Succecssfull!")
            NotificationCenter.default.post(name: .didLoginNotification, object: nil)
        })
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("Google signin Disconnected!")
    }
}

