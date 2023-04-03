//
//  MockStorageReference.swift
//  Guardian
//
//  Created by Siyu Yao on 02/04/2023.
//

import Foundation
import FirebaseStorage

/// protocol for Firebase Storage interactions to testing AudioRecordingManager()
protocol StorageReferenceProtocol {
    func child(_ pathString: String) -> StorageReferenceProtocol
    func putFile(from: URL, metadata: StorageMetadata?, completion: @escaping (StorageMetadata?, Error?) -> Void) -> StorageUploadTaskProtocol
    func listAll(completion: @escaping (TestStorageListResult?, Error?) -> Void)
    func write(toFile localURL: URL, completion: @escaping (URL?, Error?) -> Void)
    func delete(completion: @escaping (Error?) -> Void)
    
    var name: String { get }
}

protocol StorageUploadTaskProtocol { }

/// wrapper, to conforms to StorageReferenceProtocol()
class StorageReferenceWrapper: StorageReferenceProtocol {
    private let storageReference: StorageReference
        
    var name: String {
        return storageReference.name
    }
    
    init(storageReference: StorageReference) {
        self.storageReference = storageReference
    }
    
    func child(_ pathString: String) -> StorageReferenceProtocol {
        let childRef = storageReference.child(pathString)
        return StorageReferenceWrapper(storageReference: childRef)
    }
    
    func putFile(from: URL, metadata: StorageMetadata?, completion: @escaping (StorageMetadata?, Error?) -> Void) -> StorageUploadTaskProtocol {
        let task = storageReference.putFile(from: from, metadata: metadata, completion: completion)
        return task
    }
    
    func listAll(completion: @escaping (TestStorageListResult?, Error?) -> Void) {
        storageReference.listAll { (result, error) in
            if let result = result {
                let testResult = TestStorageListResult(items: result.items.map { _ in MockStorageReference() })
                completion(testResult, error)
            } else {
                completion(nil, error)
            }
        }
        }
    
    func write(toFile localURL: URL, completion: @escaping (URL?, Error?) -> Void) {
        storageReference.write(toFile: localURL, completion: completion)
    }
    
    func delete(completion: @escaping (Error?) -> Void) {
        storageReference.delete(completion: completion)
    }

}

extension StorageUploadTask: StorageUploadTaskProtocol { }

/// mock class for Firebase Storage interactions to testing AudioRecordingManager()
class MockStorageReference: StorageReferenceProtocol, Equatable {
    var childCalled = false
    var putFileCalled = false
    var listAllCalled = false
    var writeCalled = false
    var deleteCalled = false
    var listAllResult: TestStorageListResult?
    
    var name: String = "mockName"
    
    func child(_ pathString: String) -> StorageReferenceProtocol {
        childCalled = true
        return self
    }
    
    func putFile(from: URL, metadata: StorageMetadata?, completion: @escaping (StorageMetadata?, Error?) -> Void) -> StorageUploadTaskProtocol {
        putFileCalled = true
        completion(nil, nil)
        return MockStorageUploadTask()
    }
    
    func listAll(completion: @escaping (TestStorageListResult?, Error?) -> Void) {
        listAllCalled = true
        completion(listAllResult, nil) // Use the listAllResult property
    }
    
    func write(toFile localURL: URL, completion: @escaping (URL?, Error?) -> Void) {
        writeCalled = true
        let url = URL(fileURLWithPath: "mock/path")
        completion(url, nil) // Simulate successful write with a mock URL
    }
    
    func delete(completion: @escaping (Error?) -> Void) {
        deleteCalled = true
        completion(nil)
    }

    static func == (lhs: MockStorageReference, rhs: MockStorageReference) -> Bool {
        return lhs.name == rhs.name
    }
}

class MockStorageUploadTask: StorageUploadTaskProtocol { }

struct TestStorageListResult {
    let items: [MockStorageReference]
}
