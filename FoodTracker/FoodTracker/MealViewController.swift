//
//  MealViewController.swift
//  FoodTracker
//
//  Created by Sara Topic on 06/01/2018.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

import UIKit
import os.log

class MealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    //MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    /*
     This value is either passed by `MealTableViewController` in `prepare(for:sender:)`
     or constructed as part of adding a new meal.
     */
    var meal: Meal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field’s user input through delegate callbacks.
        // View controller sees itself as the delegate of its nameTextField property
        nameTextField.delegate = self
        // Enable the Save button only if the text field has a valid Meal name.
        updateSaveButtonState()
    }

//MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        // when the return is pressed the textfield stops being the first responder
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //check if the text field has text and update the save button (enabling it) if it does
        updateSaveButtonState()
        //set the title to the text the user entered
        navigationItem.title = textField.text
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    
//MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
            //this causes the app to terminate
        }
        // Set photoImageView to display the selected image.
        // show the image the user picked
        photoImageView.image = selectedImage
        
        // Dismiss the image picker
        dismiss(animated: true, completion: nil)
    }
    
    

//MARK: Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // dismisses the modal scene and animates the transition back to the meal list scene.
        dismiss(animated: true, completion: nil)
    }
    
    // This method lets you configure a view controller before it's presented.
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    // Configure the destination view controller only when the save button is pressed.
    guard let button = sender as? UIBarButtonItem, button === saveButton else {
        os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
        return
    }
    
    // create constants from the current name, image, and rating
    
    // return the value of an optional (nameTextField.text) if the optional has a value, or return a default value (empty string) otherwise
    let name = nameTextField.text ?? ""
    let photo = photoImageView.image
    let rating = ratingControl.rating
    
    // Set the meal to be passed to MealTableViewController after the unwind segue.
    meal = Meal(name: name, photo: photo, rating: rating)
}
    
//MARK: Actions
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        
        // Hide the keyboard.
        nameTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        // let the user pick a photo
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        // only from the photo lib
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    //MARK: Private Methods
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        //only enable save button if text is not empty
        saveButton.isEnabled = !text.isEmpty
    }

}

