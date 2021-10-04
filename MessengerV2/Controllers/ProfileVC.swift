//
//  ProfileVC.swift
//  MessengerV2
//
//  Created by Trần Lễ on 10/3/21.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn

class ProfileVC: UIViewController {
    
    @IBOutlet var myTableView: UITableView!
    var data = [Constant.logout]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"

        myTableView.register(UITableViewCell.self,
                             forCellReuseIdentifier: "cell")
        myTableView.dataSource = self
        myTableView.delegate = self
        // Do any additional setup after loading the view.
    }

}

extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .red
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let alertSheet = UIAlertController(title: nil, message: Constant.woopLogout, preferredStyle: .actionSheet)
        let agreeAction = UIAlertAction(title: Constant.alertAgree, style: .destructive) { [weak self] _ in
            
            guard let strongSelf = self else {
                return
            }
            
            //Logout Facebook
            FBSDKLoginKit.LoginManager().logOut()
            
            //Logout Google
            GIDSignIn.sharedInstance()?.signOut()
            
            do {
                try FirebaseAuth.Auth.auth().signOut()
                
                let vc = LoginVC()
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                strongSelf.present(nav, animated: false)
                
            } catch {
                print("Failed to Logout!")
            }
            
        }
        let cancelAction = UIAlertAction(title: Constant.alertCancel,
                                         style: .cancel,
                                         handler: nil)
        alertSheet.addAction(agreeAction)
        alertSheet.addAction(cancelAction)
        present(alertSheet, animated: true, completion: nil)
        
        
    }
}

