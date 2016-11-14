//
//  FIRImage.swift
//  Flic
//
//  Created by Sahit Penmatcha on 11/10/16.
//  Copyright © 2016 Sahit Penmatcha. All rights reserved.
//

import Foundation
import Firebase

class FIRImage
{
    var image: UIImage
    var downloadURL: URL?
    var downloadLink: String!
    var ref: FIRStorageReference!
    
    init (image: UIImage)
    {
        self.image = image
    }
}

extension FIRImage
{                        // _ allows us to use same parameter labeling as variable
    func saveProfileImage (_ userUID: String, _ completion: @escaping (Error?) -> Void)
    {
        let resizedImage = image.resized()
        let imageData = UIImageJPEGRepresentation(resizedImage, 0.9)
        
        ref = StorageReference.profileImages.reference().child(userUID) // ~/profileImages/userUID123
        downloadLink = ref.description
        
        ref.put(imageData!, metadata: nil) { (metaData, error) in
            completion(error) //will go back to completion method on top which takes in error string and returns nothing, but escapes the method (@escaping)
        }
    }
    
    func save(_ uid: String, completion: @escaping (Error?) -> Void)
    {
        let resizedImage = image.resized()
        let imageData = UIImageJPEGRepresentation(resizedImage, 0.9)
        
        ref = StorageReference.images.reference().child(uid) // ~/images/userUID123
        downloadLink = ref.description
        
        ref.put(imageData!, metadata: nil) { (metaData, error) in
            completion(error) //will go back to completion method on top which takes in error string and returns nothing, but escapes the method (@escaping)
        }
    }
    
}

extension FIRImage
{
    class func downloadProfileImage(_ uid: String, completion: @escaping (UIImage?, Error?) -> Void)
    {
                                                                    // MAX SIZE - 1 MB
        StorageReference.profileImages.reference().child(uid).data(withMaxSize: 1 * 1024 * 1024) { (imageData, error) in
            if error == nil && imageData != nil {
                let image = UIImage(data: imageData!)
                completion(image, error)
            } else {
                completion(nil, error)
            }
        }
    }
    
    class func downloadImage(uid: String, completion: @escaping (UIImage?, Error?) -> Void)
    {
        // MAX SIZE - 1 MB
        StorageReference.images.reference().child(uid).data(withMaxSize: 1 * 1024 * 1024) { (imageData, error) in
            if error == nil && imageData != nil {
                let image = UIImage(data: imageData!)
                completion(image, error)
            } else {
                completion(nil, error)
            }
        }

    }
}

// resizing the image -> smaller
private extension UIImage
{
    func resized() -> UIImage {
        let height: CGFloat = 800.0
        let ratio = self.size.width / self.size.height
        let width = height * ratio
        
        let newSize = CGSize(width: width, height: height)
        let newRectangle = CGRect(x: 0, y: 0, width: width, height: height)
        
        UIGraphicsBeginImageContext(newSize);
        self.draw(in: newRectangle)
        
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage!
        
    }
}
