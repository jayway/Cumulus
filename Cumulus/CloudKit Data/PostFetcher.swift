//
//  PostFetcher.swift
//  Cumulus
//
//  Created by Felix Hedlund on 2017-09-28.
//  Copyright © 2017 Jayway. All rights reserved.
//

import CloudKit

class PostFetcher{
    static let RecordTypePosts = "Posts"
    
    static func fetchPosts(success: @escaping ([Post]) -> (), failure: @escaping () -> ()){
        let publicDatabase = CKContainer.default().publicCloudDatabase
        let query = CKQuery(recordType: PostFetcher.RecordTypePosts, predicate: NSPredicate(format: "TRUEPREDICATE"))
        
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let queryOperation = CKQueryOperation(query: query)
        queryOperation.qualityOfService = .userInitiated
        print("Start fetching posts... \(Date())")
        var posts = [Post]()
        queryOperation.recordFetchedBlock = { record in
            posts.append(Post(record: record))
        }
        queryOperation.queryCompletionBlock = { (cursor, error) in
            print("Finished fetching posts... \(Date())")
            DispatchQueue.main.async(execute: { () -> Void in
                if let error = error{
                    print(error.localizedDescription)
                    failure()
                }else{
                    success(posts)
                }
            })
        }
        publicDatabase.add(queryOperation)
    }
}
