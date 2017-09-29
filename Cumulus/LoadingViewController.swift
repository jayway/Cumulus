//
//  LoadingViewController.swift
//  Cumulus
//
//  Created by Felix Hedlund on 2017-09-28.
//  Copyright © 2017 Jayway. All rights reserved.
//

import UIKit
import CloudKit

class LoadingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       self.checkCloudAvailability()
    }
    
    private func checkCloudAvailability(){
        CKContainer.default().accountStatus { (status, error) in
            if let _ = error{
                self.displayError()
            }
            if status == CKAccountStatus.available{
                self.proceedToApp()
            }else{
                self.displayCloudNotAvailable()
            }
            
        }
    }
    
    private func displayCloudNotAvailable(){
        let alertVC = UIAlertController(title: "iCloud not available", message: "Go to the Settings app, enable iCloud and try again.", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Try again", style: .default) { (action) in
            self.checkCloudAvailability()
        }
        alertVC.addAction(alertAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    private func proceedToApp(){
        self.performSegue(withIdentifier: "proceed", sender: self)
    }
    
    private func displayError(){
        let alertVC = UIAlertController(title: "Error", message: "Something went wrong, want to try again?", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            self.checkCloudAvailability()
        }
        alertVC.addAction(alertAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
