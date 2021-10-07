//
//  LoginVC.swift
//  MessengerV2
//
//  Created by Trần Lễ on 10/3/21.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn

class LoginVC: UIViewController {
    
   
    
    //MARK: - object View
    //imageView
    private let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "messenger")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    //scrollView
    private let scrollView : UIScrollView =  {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    //textField
    private let emailField : UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Email address..."
        //padding
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
    }()
    private let passwordField : UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Password..."
        //padding
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.isSecureTextEntry = true
        return field
    }()
    
    //Button
    private let loginButton : UIButton = {
        let button = UIButton()
        button.setTitle(Constant.login, for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    private let facebookLoginButton : FBLoginButton = {
        let button = FBLoginButton()
        button.permissions = ["email", "public_profile"]
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    private let googleLoginButton : GIDSignInButton = {
        let button = GIDSignInButton()
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.masksToBounds = true
        //button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    private var loginObserver: NSObjectProtocol?
    
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constant.login
        view.backgroundColor = .white
        
        emailField.delegate = self
        passwordField.delegate = self
        facebookLoginButton.delegate = self
        
        
        notificationSigninGoogle()
        
        //action Button Tap
        actionButton()
        //add subView
        addSubView()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        positionObjectView()
    }
    
    //Notification Signin Google
    private func notificationSigninGoogle() {
        loginObserver = NotificationCenter.default.addObserver(forName: .didLoginNotification, object: nil, queue: .main, using: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
        })
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }
    
    
    //actionButtonTap
    private func actionButton() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: Constant.register,
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapRegister))
        loginButton.addTarget(self,
                              action: #selector(didTapLoginButton),
                              for: .touchUpInside)
    }
    
    //set position view
    private func positionObjectView() {
        scrollView.frame = view.bounds
        let size = scrollView.width / 3
        let sizeWidth = scrollView.width
        imageView.frame = CGRect(x: (sizeWidth - size) / 2,
                                 y: size,
                                 width: size,
                                 height: size)
        emailField.frame = CGRect(x: 30,
                                  y: imageView.bottom + 20,
                                  width: scrollView.width - 60,
                                  height: 50)
        passwordField.frame = CGRect(x: 30,
                                     y: emailField.bottom + 10,
                                     width: scrollView.width - 60,
                                     height: 50)
        loginButton.frame = CGRect(x: 30,
                                   y: passwordField.bottom + 20,
                                   width: scrollView.width - 60,
                                   height: 50)
        facebookLoginButton.frame = CGRect(x: 30,
                                           y: loginButton.bottom + 10,
                                           width: scrollView.width - 60,
                                           height: 50)
        googleLoginButton.frame = CGRect(x: 30,
                                         y: facebookLoginButton.bottom + 10,
                                         width: scrollView.width - 60,
                                         height: 50)
    }
    
    private func addSubView() {
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(loginButton)
        scrollView.addSubview(facebookLoginButton)
        scrollView.addSubview(googleLoginButton)
    }
    
    
    //MARK: - Action
    @objc private func didTapRegister() {
        let vc = RegisterVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //loginButton
    @objc private func didTapLoginButton() {
        guard let email = emailField.text,
              let password = passwordField.text,
              !email.isEmpty,
              !password.isEmpty,
              password.count >= 6 else {
            alertNotificationLogin()
            return
        }
        
        Constant.progressHUD.show(in: view)
        //Firebase login
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] authResult, error in
            
            guard let strongSelf = self else {
                return
            }
            DispatchQueue.main.async {
                Constant.progressHUD.dismiss()
            }
            guard let result = authResult, error == nil else {
                print("Error login ...")
                return
            }
            let userLogin = result.user
            print("Login successfull with email ", userLogin)
            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
        })
    }
    
    //aler
    private func alertNotificationLogin() {
        let alert = UIAlertController(title: Constant.titleAlertWarning, message: Constant.woopLogin, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: Constant.dismiss, style: .cancel, handler: nil)
        alert.addAction(dismissAction)
        present(alert, animated: true, completion: nil)
    }
    
}

extension LoginVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            didTapLoginButton()
        }
        return true
    }
}

//MARK: - Login with Facebook
extension LoginVC: LoginButtonDelegate {
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        // no operation
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        
        guard let token = result?.token?.tokenString else {
            print("User failed to loginin with facebook")
            return
        }
        
        let facebookRequest = FBSDKLoginKit.GraphRequest(graphPath: "me",
                                                         parameters: ["fields": "email, first_name, last_name, picture.type(large)"],
                                                         tokenString: token,
                                                         version: nil,
                                                         httpMethod: .get)
        facebookRequest.start(completionHandler: { _, result, error in
            guard let result = result as? [String : Any], error == nil else {
                print("Failed to make facebook graph request")
                return
            }
            print("\(result)")
            
            guard let firstName = result["first_name"] as? String,
                  let lastname = result["last_name"] as? String,
                  let email = result["email"] as? String,
                  let picture = result["picture"] as? [String: Any],
                  let data = picture["data"] as? [String: Any],
                  let pictureUrl = data["url"] as? String else {
                print("Failed to get email and name from fb result")
                return
            }
            
//            let nameComponents = userName.components(separatedBy: " ")
//            guard nameComponents.count == 2 else {
//                return
//            }
//            let firstName = nameComponents[0]
//            let lastName = nameComponents[1]
            
            DatabaseManager.shared.userExists(with: email, completion: { exists in
                if !exists {
//                    DatabaseManager.shared.insertUser(with: ChatAppUser(emailAddress: email,
//                                                                        firstName: firstName,
//                                                                        lastName: lastName,
//                                                                        password: ""))
                    let chatUser = ChatAppUser(emailAddress: email,
                                               firstName: firstName,
                                               lastName: lastname,
                                               password: "")
                    
                    
                    
                    DatabaseManager.shared.insertUser(with: chatUser) { success in
                        if success {
                            
                            guard let url = URL(string: pictureUrl) else {
                                return
                            }
                            
                            print("Download data from Facebook")
                            
                            URLSession.shared.dataTask(with: url) { data, _, _ in
                                guard let data = data else {
                                    print("Failed to get data From Facebook")
                                    return
                                }
                                
                                print("Got data From facebook...")
                                
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
            })
            
            let credential = FacebookAuthProvider.credential(withAccessToken: token)
            print("Credential", credential)
            
            Constant.progressHUD.show(in: self.view)
            FirebaseAuth.Auth.auth().signIn(with: credential, completion:  { [weak self] authResults, error in
                
                guard let strongSelf = self else{
                    return
                }
                DispatchQueue.main.async {
                    Constant.progressHUD.dismiss()
                }
                guard authResults != nil, error == nil else {
                    if let error = error {
                        print("Facebook login failed to to", error)
                    }
                    return
                }
                print("Login with facebook successfull!")
                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
            })
        })
    }
}
