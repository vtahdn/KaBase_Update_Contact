//
//  ViewController.swift
//  KaBase_Update_Contact
//
//  Created by Viet Asc on 1/8/19.
//  Copyright © 2019 Viet Asc. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    lazy var idAlert = { (_ message: String) in
        
        let alert = UIAlertController(title: "Your Ka ♡ ID", message: "The email or pasword \(message).", preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .default, handler: { (action) in
            print("action: \(action)")
        })
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func signIn(_ sender: UIButton) {
        
        if let email = username.text, let password = password.text {
            if email == "" && password == "" {
                print("Email and password is required.")
                idAlert("is missing")
            } else {
                Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                    if error != nil {
                        print("Error: \(error!)")
                        self.idAlert("was not right")
                    } else {
                        print("Success, email: \(result!)")
                        self.performSegue(withIdentifier: "show", sender: nil)
                    }
                }
            }
        }
        
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        
        if let email = username.text, let password = password.text {
            if email == "" && password == "" {
                print("Email and password is required.")
                idAlert("is missing")
            } else {
                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    if error != nil {
                        print(error!)
                    } else {
                        self.performSegue(withIdentifier: "show", sender: nil)
                    }
                }
            }
        }
        
    }
    
    @IBAction func forgetPassword(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Forget password", message: "Enter your email", preferredStyle: .alert)
        var myText : UITextField?
        alert.addTextField { (textField) in
            myText = textField
        }
        let action = UIAlertAction(title: "Send request", style: .default) { (action) in
            print("Send request to email: \((myText?.text)!)")
            Auth.auth().sendPasswordReset(withEmail: (myText?.text)!, completion: { (error) in
                if error == nil {
                    print("Sent.")
                } else {
                    print("Sending error: \(error!)")
                }
            })
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let controller = segue.destination as! UserViewController
        let currentUser = Auth.auth().currentUser
        if currentUser?.displayName != nil {
            controller.displayName = currentUser?.displayName
        } else {
            controller.displayName = "Update your profile"
        }
        
    }
    
}

