//
//  ViewController.swift
//  meme-me
//
//  Created by Michael Bowerman on 11/14/16.
//  Copyright © 2016 Michael Bowerman. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    // MARK: Outlets

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var bottomToolbar: UIToolbar!

    // MARK: Actions

    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        pickAnImage(.photoLibrary)
    }
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        pickAnImage(.camera)
    }

    @IBAction func share(_ sender: Any) {
        let shareText = self.topText.text ?? self.bottomText.text ?? "OMG MEME"
        let image = self.generateMemedImage()
        let shareItems = [ image, shareText ] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        self.present(activityViewController,
                     animated: true,
                     completion: nil)


    }

    @IBAction func cancel(_ sender: Any) {
        self.topText.resignFirstResponder() // placeholder text not centered correctly without this
        self.topText.text = ""

        self.bottomText.resignFirstResponder() // placeholder text not centered correctly without this
        self.bottomText.text = ""

        self.imageView.image = nil
    }

    @IBAction func textChanged(_ sender: Any) {
        if let textField = sender as? UITextField {
            textField.invalidateIntrinsicContentSize()
            textField.textAlignment = .center
        }
    }

    func pickAnImage(_ sourceType: UIImagePickerControllerSourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = sourceType
        present(pickerController, animated: true, completion: nil)
    }

    // MARK: UIImagePickerControllerDelegate

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]){
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    // MARK: UITextField

    func textFieldShouldReturn(_ textField:UITextField)->Bool {
        textField.resignFirstResponder()
        return true
    }

    // MARK: UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.black,
            NSForegroundColorAttributeName : UIColor.white,
            NSStrokeWidthAttributeName : NSNumber(value: -4.0),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!
        ]

        self.topText.delegate = self
        self.topText.defaultTextAttributes = memeTextAttributes

        self.bottomText.delegate = self
        self.bottomText.defaultTextAttributes = memeTextAttributes
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    // MARK: Keyboard appear/disappear

    func keyboardWillShow(_ notification:Notification) {
        view.frame.origin.y = 0 - getKeyboardHeight(notification)
    }

    func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
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

    // MARK: meme-ifier

    func generateMemedImage() -> UIImage {
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.bounds.size)
        self.view.drawHierarchy(in: self.view.bounds, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        // Crop out the non-meme parts of the UI
        if let cgImage = memedImage.cgImage {
            let scaledCropRect = CGRect(x: self.imageView.frame.origin.x,
                                        y: self.imageView.frame.origin.y,
                                        width: self.imageView.frame.size.width,
                                        height: self.imageView.frame.size.height)

            if let croppedMemedImage = cgImage.cropping(to: scaledCropRect) {
                return UIImage(cgImage: croppedMemedImage)
            }
        }

        return memedImage // If that failed, show the ugly whitespace version
    }
}

