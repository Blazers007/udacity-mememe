//
//  ViewController.swift
//  MemeMe
//
//  Created by 张良 on 2017/1/3.
//  Copyright © 2017年 张良. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    // MARK: -- Properties
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var navigationBar: UINavigationBar!
    // center the toolbar item http://stackoverflow.com/questions/25325218/how-to-align-uibarbuttonitem-in-uitoolbar-in-ios-universal-app
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    // MARK: -- Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Init textfiled config
        initTextField([topTextField, bottomTextField])
        hideEditMemeViews()
        // detect devcice camera enabled or not
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // subscribe keyboard
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // http://stackoverflow.com/questions/38876249/cant-hide-status-bar-swift-3
    // Hide the statusbar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: -- Main logical functions
    
    func initTextField(_ textFields : [UITextField]) {
        
        let memeTextAttributes:[String:Any] = [
            NSStrokeColorAttributeName: UIColor.black,
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName: -1.0]
        
        for textField in textFields {
            textField.defaultTextAttributes = memeTextAttributes
            // It seems I should put thie line under the defaultTextAttributes define to override the value
            textField.textAlignment = .center
            textField.delegate = self
        }
    }
    
    // Show textfileds and share cancel buttons
    func showEditMemeViews() {
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        topTextField.isHidden = false
        bottomTextField.isHidden = false
        // Can share with an image
        shareButton.isEnabled = true
    }
    
    // Hide textfileds and share cancel buttons
    func hideEditMemeViews() {
        topTextField.isHidden = true
        bottomTextField.isHidden = true
        //Cannot share withou image shown
        shareButton.isEnabled = false
    }
    
    // Generate Memed Image
    func generateMemedImage() -> UIImage {
        // Hide toolbar & navbar
        navigationBar.isHidden = true
        toolbar.isHidden = true
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        // Show toolbar & navbar
        navigationBar.isHidden = false
        toolbar.isHidden = false
        // Return image
        return memedImage
    }
    
    func save(_ memedImage: UIImage) {
        //TODO: How to save ?
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originImage: imagePickerView.image!, memedImage: memedImage)
    }
    
    // MARK: -- IBActions
    
    @IBAction func pickFromCamera(_ sender: UIBarButtonItem) {
        /*
         https://makeapppie.com/2016/06/28/how-to-use-uiimagepickercontroller-for-a-camera-and-photo-library-in-swift-3-0/
         */
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.cameraCaptureMode = .photo // take photo Not video
        imagePicker.modalPresentationStyle = .fullScreen
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickFromAlbum(_ sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        // Show image picker view controller
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func shareMeme(_ sender: UIBarButtonItem) {
        let memedImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        controller.completionWithItemsHandler = { (activity, success, items, error) in
            if success {
                // Compiler will complain if missing the "self"
                self.save(memedImage)
            }
        }
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        if imagePickerView.image != nil {
            imagePickerView.image = nil
            hideEditMemeViews()
        }
    }
    
    
    // MARK: -- Album picker delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            // Show textField and enable shareButton
            showEditMemeViews()
        } else if imagePickerView.image == nil {
            // Select no image
            hideEditMemeViews()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        // No image selected currently
        if imagePickerView.image == nil {
            hideEditMemeViews()
        }
    }
    
    
    // MARK: -- TextField delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Set "TOP" "BOTTOM" to empty
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide keyboard when press enter
        textField.resignFirstResponder()
        return true
    }
    
    
    // MARK: -- Keyboard observer
    
    func keyboardWillShow(_ notification:Notification) {
        // Only move the view when the keyboard block the textfield
        let keyboardHeight = getKeyboardHeight(notification)
        if topTextField.isFirstResponder {
            // If topTextFiled is focus and the keyboard block the topTextField
            if view.frame.size.height - keyboardHeight < topTextField.frame.origin.y + topTextField.frame.size.height {
                view.frame.origin.y = 0 - keyboardHeight
            }
        } else if bottomTextField.isFirstResponder {
            // If bottomTextFiled is focus and the keyboard block the bottomTextField (seems always true)
            if view.frame.size.height - keyboardHeight < bottomTextField.frame.origin.y + bottomTextField.frame.size.height {
                view.frame.origin.y = 0 - keyboardHeight
            }
        }
    }
    
    func keyboardWillHide(_ notification:Notification) {
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
}

