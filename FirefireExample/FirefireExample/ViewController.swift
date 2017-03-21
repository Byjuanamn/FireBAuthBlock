//
//  ViewController.swift
//  FirefireExample
//
//  Created by Juan Antonio Martin Noguera on 14/03/2017.
//  Copyright © 2017 COM. All rights reserved.
//

import UIKit
import Firebase



class ViewController: UIViewController {

    @IBOutlet weak var loginOutBtn: UIBarButtonItem!
    var handle: FIRAuthStateDidChangeListenerHandle!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        handle = FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
            
            print("\(#function) ---- <USER> \(user?.email) <USER>")
            self.getUserInfo(user)
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        FIRAuth.auth()?.removeStateDidChangeListener(handle)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func registerUser(_ sender: Any) {
        showUserLoginDialog(withCommand: createNewUser)
    }
    @IBAction func signinMailPass(_ sender: Any) {
    }
    
    @IBAction func loginUser(_ sender: Any) {
        showUserLoginDialog(withCommand: login)
    }
    @IBAction func logOut(_ sender: Any) {
        do {
            try FIRAuth.auth()?.signOut()
            self.title = ""
        } catch let error {
            print("\(error.localizedDescription)")
        }
    }
    
    // MARK: Obtener info de usuario logado
    
    fileprivate func getUserInfo(_ user: FIRUser!) {
        if let _ = user {
            let uid = user?.uid
            let email = user?.email!
            self.title = email
            // let photoUrl = user?.photoURL // aun no tenemos foto ... lo dejamos para la parte de Storage
            let provider = user?.providerID
            print("+++++++++++ ---- <USER> uid: \(uid) \n email: \(email) \n provider: \(provider) <USER>")
            user?.getTokenWithCompletion({ (token, error) in
                if let _ = error {
                    print("tenemos un error -> \(error?.localizedDescription)")
                } else {
                    print("+++++++++++ ---- <USER> Token: \(token!) <USER>")
                }
            })
        }
    }
    typealias actionUserCmd = ((_ : String, _ : String) -> Void)
    fileprivate func showUserLoginDialog(withCommand actionAuth: @escaping actionUserCmd) {
        let alertController = UIAlertController(title: "FireFireExample", message: "Login", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Login", style: .default, handler: { (action) in
            let eMailtxt = (alertController.textFields?[0])! as UITextField
            let passTxt = (alertController.textFields?[1])! as UITextField
            
            if (eMailtxt.text?.isEmpty)!, (passTxt.text?.isEmpty)! {
                // no hacemos nada
            } else {
                // tratamos los datos
                actionAuth(eMailtxt.text!, passTxt.text!)
                //self.createNewUser(eMailtxt.text!, andPass: passTxt.text!)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            
        }))
        
        alertController.addTextField { (txtField) in
            txtField.placeholder = "por favor escriba su email"
            txtField.textAlignment = .natural
        }
        
        alertController.addTextField { (txtField) in
            txtField.placeholder = "su password"
            txtField.textAlignment = .natural
            txtField.isSecureTextEntry = true
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    /// [createNewUser]: Metodo crear un usuario nuevo, basado en email/password
    /// - name: email del usuario
    /// - pass: Password del usuario
    /// - Returns: Void
    fileprivate func createNewUser(_ name: String, andPass pass: String) {
        FIRAuth.auth()?.createUser(withEmail: name, password: pass, completion: { (user, error) in
            if let _ = error {
                print("tenemos un error -> \(error?.localizedDescription)")
                return
            }
            
            print("\(user)")
        })

    }
    
    fileprivate func login(_ name: String, andPass pass: String) {
        FIRAuth.auth()?.signIn(withEmail: "juan@midominio.com", password: "12345678", completion: { (
            user, error) in
            
            if let _ = error {
                print("tenemos un error -> \(error?.localizedDescription)")
                return
            }
            print("user: \(user?.email!)")
            
        })

    }

}
































