//
//  PostSaver.swift
//  Cumulus
//
//  Created by Felix Hedlund on 2017-09-28.
//  Copyright © 2017 Jayway. All rights reserved.
//

import UIKit
import CloudKit

class PostSaver{
    
    static func savePost(message: String, image: UIImage?, success: @escaping () -> (), failure: @escaping () -> ()){
        func writeImage(image: UIImage) -> URL {
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsURL.appendingPathComponent(NSUUID().uuidString + ".png")
            if let imageData = UIImagePNGRepresentation(image) {
                do{
                    try imageData.write(to: fileURL)
                }catch{
                    
                }
            }
            return fileURL
        }
        
        
        let newRecord:CKRecord = CKRecord(recordType: "Posts")
        if let image = image{
            let asset = CKAsset(fileURL: writeImage(image: image))
            newRecord["postImage"] = asset
        }
        newRecord["postMessage"] = message as CKRecordValue
        
        CKContainer.default().publicCloudDatabase.save(newRecord) { (record, error) in
            if let e = error{
                print(e.localizedDescription)
                failure()
            }else{
                success()
            }
        }
        
    }
    
}
