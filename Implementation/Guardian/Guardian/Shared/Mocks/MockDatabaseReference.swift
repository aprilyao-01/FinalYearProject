//
//  MockDatabaseReference.swift
//  Guardian
//
//  Created by Siyu Yao on 02/04/2023.
//

import Foundation
import FirebaseDatabase

/// protocol for Firebase database interactions to testing MapVM()
protocol DatabaseReferenceProtocol {
    var key: String? { get }
    
    func child(_ pathString: String) -> DatabaseReferenceProtocol
    func setValue(_ value: Any?, withCompletionBlock block: @escaping (Error?, DatabaseReferenceProtocol) -> Void)
    func removeValue(completionBlock block: @escaping (Error?, DatabaseReferenceProtocol) -> Void)
    func observe(_ eventType: DataEventType, with block: @escaping (DataSnapshot) -> Void) -> UInt
}

/// wrapper, to conforms to DatabaseReferenceProtocol()
class DatabaseReferenceWrapper: DatabaseReferenceProtocol {
    private let wrappedReference: DatabaseReference

    init(_ reference: DatabaseReference) {
        self.wrappedReference = reference
    }

    var key: String? {
        return wrappedReference.key
    }

    func child(_ pathString: String) -> DatabaseReferenceProtocol {
        return DatabaseReferenceWrapper(wrappedReference.child(pathString))
    }

    func setValue(_ value: Any?, withCompletionBlock block: @escaping (Error?, DatabaseReferenceProtocol) -> Void) {
        wrappedReference.setValue(value) { (error, reference) in
            block(error, DatabaseReferenceWrapper(reference))
        }
    }

    func removeValue(completionBlock block: @escaping (Error?, DatabaseReferenceProtocol) -> Void) {
        wrappedReference.removeValue { (error, reference) in
            block(error, DatabaseReferenceWrapper(reference))
        }
    }

    func observe(_ eventType: DataEventType, with block: @escaping (DataSnapshot) -> Void) -> UInt {
        return wrappedReference.observe(eventType, with: block)
    }
}

/// mock class for Firebase database interactions to testing MapVM()
class MockDatabaseReference: DatabaseReferenceProtocol {
    var key: String?
    var keyPath: String?
    var calledStatus: [String: Bool] = [
        "setValue": false,
        "removeValue": false,
        "observe": false
    ]

    init(key: String? = nil) {
        self.key = key
        self.keyPath = key
    }

    func child(_ pathString: String) -> DatabaseReferenceProtocol {
        let newKey = (key == nil) ? pathString : "\(key!)/\(pathString)"
        return MockDatabaseReference(key: newKey)
    }

    func setValue(_ value: Any?, withCompletionBlock block: @escaping (Error?, DatabaseReferenceProtocol) -> Void) {
        calledStatus["setValue"] = true
        block(nil, self)
    }

    func removeValue(completionBlock block: @escaping (Error?, DatabaseReferenceProtocol) -> Void) {
        calledStatus["removeValue"] = true
        block(nil, self)
    }

    func observe(_ eventType: DataEventType, with block: @escaping (DataSnapshot) -> Void) -> UInt {
        calledStatus["observe"] = true
        return 1
    }
}
