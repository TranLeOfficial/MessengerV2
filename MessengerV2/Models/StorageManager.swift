//
//  Model.swift
//  MessengerV2
//
//  Created by Trần Lễ on 10/3/21.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    static let shared = StorageManager()
    
    private let storage = Storage.storage().reference()
    
    public typealias UploadPictureCompletion = (Result<String, Error>) -> Void
    //Image
    public func uploadProfilePicture(with data: Data,
                                     fileName: String,
                                     completion: @escaping UploadPictureCompletion) {
        storage.child("image/\(fileName)").putData(data, metadata: nil, completion: { metaData, error in
            guard error == nil else {
                //fail to upload data firevase for picture
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
        })
        
        self.storage.child("image/\(fileName)").downloadURL { url, Error in
            guard let url = url else {
                print("Failed to load Image")
                completion(.failure(StorageErrors.failedToGetDownloadUrl))
                return
            }
            let urlString = url.absoluteString
            print("download url return: ", urlString)
            completion(.success(urlString)) 
        }
    }
    
    public enum StorageErrors: Error {
        case failedToUpload
        case failedToGetDownloadUrl
    }
    
}
