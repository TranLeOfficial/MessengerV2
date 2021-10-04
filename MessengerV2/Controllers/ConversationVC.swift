//
//  ViewController.swift
//  MessengerV2
//
//  Created by Trần Lễ on 10/3/21.
//

import UIKit

import FirebaseAuth

class ConversationVC: UIViewController {
    
    
    //MARK: - Object View
    private let myTableView: UITableView =  {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private let noConversationLabel: UILabel = {
        let label = UILabel()
        label.text = "No conversations!"
        label.textAlignment = .center
        label.textColor = .red
        label.font = .systemFont(ofSize: 21, weight: .medium)
        label.isHidden = true
        return label
    }()
    
    

    
    //MARK: - Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Chat"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose,
                                                            target: self,
                                                            action: #selector(didTapComposeButton))
        
        view.addSubview(myTableView)
        view.addSubview(noConversationLabel)
        setupTableView()
        fetchConversation()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        let isLoggedIn = UserDefaults.standard.bool(forKey: "logged_in")
//        if !isLoggedIn {
//            let vc = LoginVC()
//            let nav = UINavigationController(rootViewController: vc)
//            nav.modalPresentationStyle = .fullScreen
//            present(nav, animated: true, completion: nil)
//        }
        validateAuth()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        myTableView.frame = view.bounds
    }
    
    private func validateAuth() {
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let vc = LoginVC()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: false, completion: nil)
        }
    }

    private func setupTableView() {
        myTableView.dataSource = self
        myTableView.delegate = self
    }
    
    private func fetchConversation() {
        myTableView.isHidden = false
    }
    
    //MARK: - OBJC
    @objc private func didTapComposeButton() {
        let vc = NewConversationVC()
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }

}

//MARK: - TableView
extension ConversationVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Hello world"
        return cell
    }
    
    //Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = ChatVC()
        vc.title = "NhanTT13"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}

