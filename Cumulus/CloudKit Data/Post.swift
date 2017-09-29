//
//  Post.swift
//  Cumulus
//
//  Created by Felix Hedlund on 2017-09-28.
//  Copyright © 2017 Jayway. All rights reserved.
//

import CloudKit

class Post{
    var record: CKRecord!
    
    struct keys{
        static let message = "postMessage"
        static let image = "postImage"
    }
    
    init(record: CKRecord){
        self.record = record
    }
    
    func getMessage() -> String?{
        if let message = record[keys.message] as? String{
            return message
        }
        return nil
    }
    
    func getImageURL() -> URL?{
        if let asset = record[keys.image] as? CKAsset{
            return asset.fileURL
        }
        return nil
    }
}
