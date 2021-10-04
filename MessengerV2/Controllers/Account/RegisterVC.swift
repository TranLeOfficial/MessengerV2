//
//  RegisterVC.swift
//  MessengerV2
//
//  Created by Trần Lễ on 10/3/21.
//

import UIKit

import FirebaseAuth

class RegisterVC: UIViewController {
        
    //MARK: - object View
    //imageView
    private let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.gray.cgColor
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
        field.keyboardType = .emailAddress
        //padding
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
    }()
    private let firstNameField : UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "First Name..."
        //padding
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
    }()
    private let lastNameField : UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Last Name..."
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
    private let rePasswordField : UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Re - Password..."
        //padding
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.isSecureTextEntry = true
        return field
    }()
    
    //Button
    private let registerButton : UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    

    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Register"
        view.backgroundColor = .white
        
        emailField.delegate = self
        passwordField.delegate = self
        
        //action Button Tap
        actionButton()
        //add subView
        addSubView()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        positionObjectView()
    }
    
    
    //actionButtonTap
    private func actionButton() {
        //register
        registerButton.addTarget(self,
                              action: #selector(didTapRegisterButton),
                              for: .touchUpInside)
        //addPhoto
        let gesture = UITapGestureRecognizer(target: self,
                                          action: #selector(didTapChangePhoto))
        imageView.addGestureRecognizer(gesture)
        imageView.isUserInteractionEnabled = true
        scrollView.isUserInteractionEnabled = true
        
    }
    
    //set position view
    private func positionObjectView() {
        scrollView.frame = view.bounds
        let size = scrollView.width / 3
        
        let sizeWidth = scrollView.width
        imageView.frame = CGRect(x: (sizeWidth - size) / 2,
                                 y: size - 100,
                                 width: size,
                                 height: size)
        imageView.layer.cornerRadius = imageView.width / 2
        
        emailField.frame = CGRect(x: 30,
                                 y: imageView.bottom + 20,
                                 width: scrollView.width - 60,
                                 height: 50)
        firstNameField.frame = CGRect(x: 30,
                                 y: emailField.bottom + 10,
                                 width: scrollView.width - 60,
                                 height: 50)
        lastNameField.frame = CGRect(x: 30,
                                 y: firstNameField.bottom + 10,
                                 width: scrollView.width - 60,
                                 height: 50)
        passwordField.frame = CGRect(x: 30,
                                 y: lastNameField.bottom + 10,
                                 width: scrollView.width - 60,
                                 height: 50)
        rePasswordField.frame = CGRect(x: 30,
                                 y: passwordField.bottom + 10,
                                 width: scrollView.width - 60,
                                 height: 50)
        registerButton.frame = CGRect(x: 30,
                                 y: rePasswordField.bottom + 20,
                                 width: scrollView.width - 60,
                                 height: 50)
    }
    
    private func addSubView() {
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(registerButton)
        scrollView.addSubview(lastNameField)
        scrollView.addSubview(firstNameField)
        scrollView.addSubview(rePasswordField)
    }
    
    
    //MARK: - Action
    
    //loginButton
    @objc private func didTapRegisterButton() {
        guard let email = emailField.text,
              let password = passwordField.text,
              let firstName = firstNameField.text,
              let lastName = lastNameField.text,
              let rePassword = rePasswordField.text,
              !firstName.isEmpty,
              !lastName.isEmpty,
              !rePassword.isEmpty,
              !email.isEmpty,
              !password.isEmpty,
              password.count >= 6,
              rePassword == password else {
            alertNotificationLogin()
            return
        }
        
        //Firebase register
        //MARK: - Register User in Firebase
        DatabaseManager.shared.userExists(with: email, completion:  { [weak self] exists in
            guard let strongSelf = self else{
                return
            }
            
            guard !exists else {
                //user already exist
                strongSelf.alertNotificationLogin(message: "Looks like a user account for that email address already exists. ")
                return
            }
            
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion:  { authResult, error in
                
                guard authResult != nil, error == nil else {
                    print("Error creating User")
                    return
                }
    //            let newUser = result.user
    //            print("Successfull Create User ", newUser)
                DatabaseManager.shared.insertUser(with: ChatAppUser(emailAddress: email,
                                                                    firstName: firstName,
                                                                    lastName: lastName,
                                                                    password: password))
                
                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
            })
        })
    }
    
    //alert
    private func alertNotificationLogin(message: String = Constant.woopRegister) {
        let alert = UIAlertController(title: Constant.titleAlertWarning, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: Constant.dismiss, style: .cancel, handler: nil)
        alert.addAction(dismissAction)
        present(alert, animated: true, completion: nil)
    }
    //Add photo
    @objc private func didTapChangePhoto() {
        presentPhotoActionSheet()
    }

}

//Text Field delegate
extension RegisterVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            didTapRegisterButton()
        }
        return true
    }
}

//MARK: - Change to Photo
extension RegisterVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentPhotoActionSheet() {
        let alert = UIAlertController(title: Constant.titleAlertPhoto, message: Constant.messageAlertPhoto, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: Constant.alertCancel, style: .cancel, handler: nil)
        let takePhotoAction = UIAlertAction(title: Constant.alertTakePhoto, style: .default) { _ in
            self.presentCamera()
        }
        let choosePhotoAction = UIAlertAction(title: Constant.alertChoosePhoto, style: .default) { _ in
            self.presentPhotoLibrary()
        }
        alert.addAction(cancelAction)
        alert.addAction(takePhotoAction)
        alert.addAction(choosePhotoAction)
        present(alert, animated: true, completion: nil)
    }
    
    //Camera
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true, completion: nil)
    }
    
    //Library
    func presentPhotoLibrary() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let selectImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.imageView.image = selectImage
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

