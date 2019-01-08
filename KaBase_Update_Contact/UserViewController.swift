//
//  UserViewController.swift
//  KaBase_Update_Contact
//
//  Created by Viet Asc on 1/8/19.
//  Copyright © 2019 Viet Asc. All rights reserved.
//

import UIKit
import Firebase

class UserViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    
    let data: [String] = ["Update Profile", "Change Password", "Delete User", "Verify Email"]
    var displayName: String?
    
    lazy var alert = { (_ title: String, _ message: String) in
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .default, handler: { (action) in
        })
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.layer.cornerRadius = imageView.bounds.width / 2
        imageView.clipsToBounds = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        nameLabel.text = displayName!
        
    }
    
    @IBAction func signOut(_ sender: UIButton) {
        
        do {
            try Auth.auth().signOut()
            dismiss(animated: true, completion: nil)
        } catch {
            print(error)
        }
        
    }
    
}

extension UserViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let user = Auth.auth().currentUser
        let cell = tableView.cellForRow(at: indexPath)
        let cellName = cell?.textLabel?.text
        
        switch cellName {
        case "Delete User":
            user?.delete(completion: { (error) in
                if error != nil {
                    self.alert("Profile - Deleted.","The contact is not removed.")
                    print("Delete error: \(error!)")
                } else {
                    print("Delete.")
                    self.dismiss(animated: true, completion: nil)
                }
            })
        case "Change Password":
            let alert = UIAlertController(title: "Change Password", message: "Enter your new password.", preferredStyle: .alert)
            var myText: UITextField?
            alert.addTextField { (textField) in
                myText = textField
            }
            let action = UIAlertAction(title: "Confirm", style: .default) { (action) in
                let newPassword = myText?.text
                user?.updatePassword(to: newPassword!, completion: { (error) in
                    if error == nil {
                        print("Passsword changed.")
                    }
                })
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        case "Update Profile":
            let alert = UIAlertController(title: "Update profile", message: "Enter your new profile", preferredStyle: .alert)
            var displayNameText: UITextField?
            var photoURLText: UITextField?
            alert.addTextField { (textField) in
                displayNameText = textField
                displayNameText?.placeholder = "Contact name."
            }
            alert.addTextField { (textField) in
                photoURLText = textField
                photoURLText?.placeholder = "Photo URL."
            }
            let action = UIAlertAction(title: "Confirm", style: .default) { (action) in
                let changeRequest = user?.createProfileChangeRequest()
                changeRequest?.displayName = displayNameText?.text
                changeRequest?.photoURL = URL(string: (photoURLText?.text)!)
                changeRequest?.commitChanges(completion: { (error) in
                    if error != nil {
                        print(error!)
                    } else {
                        print("Profile changed.")
                    }
                })
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        case "Verify Email":
            if (user?.isEmailVerified)! {
                self.alert("Profile","Your email is verified.")
            } else {
                user?.sendEmailVerification(completion: { (error) in
                    if error != nil {
                        print("Email sent.")
                    }
                })
                self.alert("Profile","Your email verification is sent.")
            }
        default:
            break
        }
        
    }
    
}

extension UserViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return data.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        let font = UIFont(name: (cell.textLabel?.font.fontName)!, size: 13)
        cell.textLabel?.font = font
        cell.textLabel?.textColor = .darkGray
        return cell
        
    }
    
    
}
