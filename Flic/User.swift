//
//  User.swift
//  Flic
//
//  Created by Sahit Penmatcha on 11/10/16.
//  Copyright © 2016 Sahit Penmatcha. All rights reserved.
//

import Foundation
import Firebase

class User
{
    let uid: String
    var username: String
    var fullName: String
    var bio: String
    var website: String
    var profileImage: UIImage?
    
    var follows: [User]
    var followedBy: [User]
    
    // MARK: - Initializers
    
    init (uid: String, username: String, fullName: String, bio: String, website: String, follows: [User], followedBy: [User],  profileImage: UIImage?)
    {
        self.uid = uid;
        self.username = username;
        self.fullName = fullName;
        self.bio = bio;
        self.website = website;
        self.follows = follows;
        self.followedBy = followedBy;
        self.profileImage = profileImage;
    }
    
    init (dictionary: [String: Any])
    {
        uid = dictionary["uid"] as! String
        username = dictionary["username"] as! String
        fullName = dictionary["fullName"] as! String
        bio = dictionary["bio"] as! String
        website = dictionary["website"] as! String
        
        // follows
        self.follows = []
        if let followsDict = dictionary["follows"] as? [String : Any] // for loop under will get called ONLY if the dictionary["follows"] has something in it
        {
            //dictionary so you need two values (key, value) -> dont care about key (userId) because it wont be used so its put as _
            for (_, userDict) in followsDict {
                if let userDict = userDict as? [String : Any] {
                    self.follows.append(User(dictionary: userDict)) //this wont create a never ending loop - ^ look above
                }
            }
        }
        
        // followedBy
        followedBy = []
        if let followedByDict = dictionary["followedBy"] as? [String : Any] // for loop under will get called ONLY if the dictionary["followedBy"] has something in it
        {
            //dictionary so you need two values (key, value) -> dont care about key (userId) because it wont be used so its put as _
            for (_, userDict) in followedByDict {
                if let userDict = userDict as? [String : Any] { //if let means if its not null
                    self.followedBy.append(User(dictionary: userDict)) //this wont create a never ending loop - ^ look above
                }
            }
        }

   
    }
    
    func save(completion: @escaping (Error?) -> Void)
    {
        // 1 - save text details about user
        let ref = DatabaseReference.users(uid: uid).reference()
        ref.setValue(toDictionary());
        
        // 2 - save follows - referencing follows path, creating new path for every user under their unique id, storing their details in path
        for user in follows {
            ref.child("follows/\(user.uid)").setValue(user.toDictionary())
        }
        
        // 3 - save followed by - same as follows
        for user in followedBy {
            ref.child("followedBy/\(user.uid)").setValue(user.toDictionary());
        }
        
        // 4 - save the profileImage
        if let profileImage = self.profileImage               // if profileImage is != nil
        {
                let firImage = FIRImage(image: profileImage)
            firImage.saveProfileImage(self.uid, { (error) in //the profile image will take time to save in background thread, after its done, the completion will tell it to escape out of the method
                completion(error) //will call completion in the save method parameter
            })
            
        }
    }
    
    
    func toDictionary() -> [String: Any] {
        return [
            "uid" : uid,
            "username" : username,
            "fullName" : fullName,
            "bio" : bio,
            "website" : website
        ]
    }
    
    
}
