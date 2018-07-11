//
//  LoginVC.swift
//  MojotGrad
//
//  Created by Teddy on 1/15/18.
//  Copyright © 2018 Teddy. All rights reserved.
//
import TransitionButton
import UIKit
import FBSDKLoginKit
import Reachability

class LoginVC: UIViewController {
    
    var dict : [String : AnyObject]!
    let network: NetworkManager = NetworkManager.sharedInstance
    @IBOutlet weak var loginButton: TransitionButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //ReachabilityMenager.shared.addListener(listener: self)
        
        network.reachability.whenReachable = { _ in
            self.loginButton.isEnabled = true
        }
        
        network.reachability.whenUnreachable = { _ in
            self.loginButton.isEnabled = false
            self.showAlert(withTitle: "Network Disabled", message: "Please enable WiFi or Cellular Data")
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //ReachabilityMenager.shared.removeListener(listener: self)
        NetworkManager.stopNotifier()
    }
    
    @IBAction func buttonAction(_ button: TransitionButton) {
        button.startAnimation()
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {
            
            sleep(2) // 3: Do your networking task or background work here.
            
            DispatchQueue.main.async(execute: { () -> Void in
                // 4: Stop the animation, here you have three options for the `animationStyle` property:
                // .expand: useful when the task has been compeletd successfully and you want to expand the button and transit to another view controller in the completion callback
                // .shake: when you want to reflect to the user that the task did not complete successfly
                // .normal
                button.stopAnimation(animationStyle: .expand, completion: {
                    if let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarC") as? UITabBarController {
                        self.present(tabBarController, animated: false, completion: nil)
                    }
                })
            })
        })
    }
   
    @IBAction func fbButtonTapped(_ sender: Any) {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        self.getFBUserData()
                        fbLoginManager.logOut()
                    }
                }
            }
        }
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as! [String : AnyObject]
                    print(result!)
                    print(self.dict)
                }
            })
        }
    }
}
