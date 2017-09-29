//
//  CreatePostViewController.swift
//  Cumulus
//
//  Created by Felix Hedlund on 2017-09-28.
//  Copyright © 2017 Jayway. All rights reserved.
//

import UIKit

class CreatePostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    @IBOutlet weak var postMessageTextField: UITextField!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    
    var pickedImage: UIImage?
    var message: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func didPressCancel(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func didPressSave(_ sender: Any) {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.startAnimating()
        activityIndicator.activityIndicatorViewStyle = .gray
        activityIndicator.tintColor = UIColor.black
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicator)
        if let m = message{
            PostSaver.savePost(message: m, image: pickedImage, success: {
                self.navigationController?.dismiss(animated: true, completion: nil)
            }, failure: {
                self.setSaveButton()
            })
        }else{
            setSaveButton()
        }
    }
    
    private func setSaveButton(){
        let item = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.didPressSave))
        self.navigationItem.rightBarButtonItem = item
    }
    
    @IBAction func didPressAddImage(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Pick image", message: nil, preferredStyle: .actionSheet)
        let libraryAction = UIAlertAction(title: "Library", style: .default, handler: { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary;
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }
        })
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(libraryAction)
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        self.message = self.postMessageTextField.text
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.postMessageTextField.resignFirstResponder()
        return true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let orientedImage = image.fixedOrientation()
        self.addImageButton.backgroundColor = UIColor.clear
        self.backgroundImageView.image = orientedImage
        self.pickedImage = orientedImage
        picker.dismiss(animated: true, completion: nil)
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
