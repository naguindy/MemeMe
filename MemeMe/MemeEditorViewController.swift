//
//  MemeEditorViewController.swift
//  MemeMe 1.0
//
//  Created by Noha on 11.07.19.
//  Copyright © 2019 udacity. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController{
   
    @IBOutlet weak var navbar: UINavigationBar!
    
    @IBOutlet weak var photoToolbar: UIToolbar!
    @IBOutlet weak var camera: UIBarButtonItem!
    
    @IBOutlet weak var imageViewPicker: UIImageView!
    
    @IBOutlet weak var topTextField: UITextField!
    
    @IBOutlet weak var bottomTextField: UITextField!
    
 
    
    @IBOutlet weak var shareAction: UIBarButtonItem!
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        .strokeColor : UIColor.black,
        .foregroundColor: UIColor.white,
        .font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,.strokeWidth: -2.0]
    
    
    override func viewWillAppear(_ animated: Bool) {
        camera.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //attributes of topTextField
        imageViewPicker.backgroundColor = .black
        setupTextField(textField: topTextField, text: "TOP")
        setupTextField(textField: bottomTextField, text: "BOTTOM")
        
        shareAction.isEnabled = false
        //Image
        imageViewPicker.contentMode = .scaleAspectFit
        imageViewPicker.image = nil
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func pickImageFromAlbum(_ sender: UIButton) {
       
        presentPickerViewController(source: .photoLibrary)
    }
    @IBAction func pickImageFromCamera(_ sender: Any) {
        presentPickerViewController(source: .camera)
    }
    
    
    @IBAction func shareMeme(_ sender: UIBarButtonItem) {
        let memedImage = generatedMemedImage()
        let controller = UIActivityViewController(activityItems: [memedImage as Any], applicationActivities: nil)
        present(controller, animated: true, completion: nil)
        controller.completionWithItemsHandler = {
            (activity, completed, items, error) in
            if completed {
                self.save()
            }
        }
    }
    //MARK: CancelButton
    @IBAction func cancelButton(_ sender: UIButton) {
       dismiss(animated: true, completion: nil)
    }
    
    
}

extension MemeEditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    //MARK: implementing Image Picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let newImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imageViewPicker.backgroundColor = UIColor.black
        imageViewPicker.image = newImage
        shareAction.isEnabled = true
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func presentPickerViewController(source: UIImagePickerController.SourceType) {
        //TODO: - Create a `UIImagePickerController`, set its source, and present it here.
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = source
        present(pickerController, animated: true, completion: nil)
        
    }
    //MARK: generate memedImage
    func generatedMemedImage()-> UIImage{
        self.photoToolbar.isHidden = true
        self.navbar.isHidden = true
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.photoToolbar.isHidden = false
        self.navbar.isHidden = false
        return memedImage
    }
    //MARK: save Meme
    func save(){
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, image: imageViewPicker.image!, memedImage: generatedMemedImage())
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(meme)
        print(meme)
        dismiss(animated: true, completion: nil)
    }
    
    
}
extension MemeEditorViewController : UITextFieldDelegate{
    
    func setupTextField(textField: UITextField, text: String) {
        // TODO: Set text field attributes, delegate, and text here
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.text = text
        textField.delegate = self
        textField.clearsOnInsertion = true
    }
    //MARK: TextFieldDelegation
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.selectedTextRange = nil
        
        if  textField.clearsOnInsertion {
            textField.text = ""
            textField.clearsOnInsertion = false
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    //MARK: Shift image
    @objc func keyboardWillShow(_ notification : Notification){
        if self.bottomTextField.isEditing {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    @objc func keyboardWillHide(_ notification : Notification){
        view.frame.origin.y = 0.0
        
    }
    func getKeyboardHeight(_ notification: Notification) -> CGFloat{
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        print(keyboardSize.cgRectValue.height)
        return keyboardSize.cgRectValue.height
    }
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
}
