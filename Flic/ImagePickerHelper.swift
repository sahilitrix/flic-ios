//
//  ImagePickerHelper.swift
//  Flic
//
//  Created by Sahit Penmatcha on 11/11/16.
//  Copyright © 2016 Sahit Penmatcha. All rights reserved.
//

import UIKit
import MobileCoreServices

// typealias is name that can be used everywhere in code instead of whatever it is set to: ((UIImage?) -> Void)!
typealias ImagePickerHelperCompletion = ((UIImage?) -> Void)!

class ImagePickerHelper: NSObject
{
    // displays actionsheet, imagePickerController ==> needs reference to whatever viewController is displayed
    
    // better if 'weak' -> Strong variables when deleted, their reference sticks around in memory for some time -> Weak variables, reference and object get deleted
    weak var viewController: UIViewController!
    var completion: ImagePickerHelperCompletion
    
    init(viewController: UIViewController, completion: ImagePickerHelperCompletion)
    {
        self.viewController = viewController;
        self.completion = completion;
        
        super.init() //initialize the rest of default values for NSObject
        
        self.showPhotoSourceSelection()
    }
    
    // create action sheet to show options
    func showPhotoSourceSelection()
    {
        let actionSheet = UIAlertController(title: "Choose a Photo", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { action in
            self.showImagePicker(sourceType: .camera)
        })
        let photosLibraryAction = UIAlertAction(title: "Gallery", style: .default, handler: { action in
            self.showImagePicker(sourceType: .photoLibrary)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(cameraAction);
        actionSheet.addAction(photosLibraryAction)
        actionSheet.addAction(cancelAction)
        
        viewController.present(actionSheet, animated:true, completion: nil)
    }
    
    func showImagePicker(sourceType: UIImagePickerControllerSourceType)
    {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true        // if user wants to crop, etc
        imagePicker.sourceType = sourceType
        imagePicker.mediaTypes = [kUTTypeImage as String] // if media is *picture*, video, gif, etc
        imagePicker.delegate = self
        
        viewController.present(imagePicker, animated: true, completion: nil)
        
    }
    
}

// similar to onRecieve method in java
extension ImagePickerHelper: UIImagePickerControllerDelegate,
    UINavigationControllerDelegate
{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    // after user picks image and data is retrieved
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        viewController.dismiss(animated: true, completion: nil)
        completion(image)
    }
}
