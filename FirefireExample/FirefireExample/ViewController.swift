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

    var handle: FIRAuthStateDidChangeListenerHandle!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        handle = FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
            print("\(#function) ---- <USER> \(user?.email) <USER>")
            if let _ = user {
                let uid = user?.uid
                let email = user?.email!
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

    @IBAction func signinMailPass(_ sender: Any) {
        FIRAuth.auth()?.createUser(withEmail: "juan@midominio.com", password: "12345678", completion: { (user, error) in
            if let _ = error {
                print("tenemos un error -> \(error?.localizedDescription)")
                return
            }
            
            print("\(user)")
        })
    }
    
    @IBAction func loginUser(_ sender: Any) {
        FIRAuth.auth()?.signIn(withEmail: "juan@midominio.com", password: "12345678", completion: { (
            user, error) in
            
            if let _ = error {
                print("tenemos un error -> \(error?.localizedDescription)")
                return
            }
            print("user: \(user?.email!)")
            
        })
    
    }
    
    // MARK: Obtener info de usuario logado
    

}

