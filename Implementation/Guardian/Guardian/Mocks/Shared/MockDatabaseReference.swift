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
    func observe(_ eventType: DataEventType, with block: @escaping (DataSnapshotProtocol) -> Void) -> UInt
    func updateChildValues(_ values: [AnyHashable: Any], withCompletionBlock block: @escaping (Error?, DatabaseReferenceProtocol) -> Void)
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

    func observe(_ eventType: DataEventType, with block: @escaping (DataSnapshotProtocol) -> Void) -> UInt {
        return wrappedReference.observe(eventType, with: { snapshot in
            block(snapshot as DataSnapshotProtocol)
        })
    }
    
    func updateChildValues(_ values: [AnyHashable: Any], withCompletionBlock block: @escaping (Error?, DatabaseReferenceProtocol) -> Void) {
        wrappedReference.updateChildValues(values, withCompletionBlock: { (error, reference) in
            block(error, DatabaseReferenceWrapper(reference))
        })
    }
}

/// mock class for Firebase database interactions to testing MapVM()
class MockDatabaseReference: DatabaseReferenceProtocol {
    var key: String?
    var keyPath: String?
//    var calledStatus: [String: Bool] = [
//        "child": false,
//        "setValue": false,
//        "removeValue": false,
//        "observe": false,
//        "updateChildValues": false
//    ]
    
    // use callbacks to simulate the success and failure cases
//    var setValueCallback: ((Any?) -> Result<Void, Error>)?
    var removeValueCallback: (() -> Result<Void, Error>)?
    var updateChildValuesCallback: ((Any?) -> Result<Void, Error>)?
    
    var setValueCallback: ((Any) -> (Result<Void, Error>))? = nil
    private(set) var _calledStatus: [String: Bool] = ["observe": false, "setValue": false, "updateChildValues": false, "removeValue": false, "child": false]
    
    var calledStatus: [String: Bool] {
        get {
            return _calledStatus
        }
    }

    init(key: String? = nil) {
        self.key = key
        self.keyPath = key
    }

    func child(_ pathString: String) -> DatabaseReferenceProtocol {
        let newKey = (key == nil) ? pathString : "\(key!)/\(pathString)"
        _calledStatus["child"] = true
        return MockDatabaseReference(key: newKey)
    }
    
    

    func setValue(_ value: Any?, withCompletionBlock block: @escaping (Error?, DatabaseReferenceProtocol) -> Void) {
        if let setValueCallback = setValueCallback, let value = value {
            let result = setValueCallback(value)
            
            DispatchQueue.main.async { [weak self] in
                self?._calledStatus["setValue"] = true
                switch result {
                case .success:
                    block(nil, self!)
                case .failure(let error):
                    block(error, self!)
                }
            }
        }
    }


    func removeValue(completionBlock block: @escaping (Error?, DatabaseReferenceProtocol) -> Void) {
        _calledStatus["removeValue"] = true
        let result = removeValueCallback?() ?? .success(())
        switch result {
        case .success:
            block(nil, self)
        case .failure(let error):
            block(error, self)
        }
    }

    func updateChildValues(_ values: [AnyHashable: Any], withCompletionBlock block: @escaping (Error?, DatabaseReferenceProtocol) -> Void) {
        _calledStatus["updateChildValues"] = true
        let result = updateChildValuesCallback?(values) ?? .success(())
        switch result {
        case .success:
            block(nil, self)
        case .failure(let error):
            block(error, self)
        }
    }

    func observe(_ eventType: DataEventType, with block: @escaping (DataSnapshotProtocol) -> Void) -> UInt {
        _calledStatus["observe"] = true
        return 0
    }
}


protocol DataSnapshotProtocol {
    var value: Any? { get }
}

extension DataSnapshot: DataSnapshotProtocol {}

class MockDataSnapshot: DataSnapshotProtocol {
    var mockValue: Any?
    
    init(value: Any?) {
        self.mockValue = value
    }
    
    var value: Any? {
        return mockValue
    }
}
