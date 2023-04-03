//
//  MockActivityIndicator.swift
//  Guardian
//
//  Created by Siyu Yao on 02/04/2023.
//

import Foundation
import UIKit

/// protocol for testing any code using ActivityIndicator()
protocol ActivityIndicatorProtocol {
    func showActivityIndicator()
    func hideActivityIndicator()
}

/// mock class for testing any code using ActivityIndicator()
class MockActivityIndicator: ActivityIndicatorProtocol {
    private let onHide: () -> Void

    init(onHide: @escaping () -> Void) {
        self.onHide = onHide
    }

    func showActivityIndicator() {
        // Do nothing for testing
    }

    func hideActivityIndicator() {
        onHide()
    }
}

/// wrapper, to conforms to ActivityIndicatorProtocol()
class ActivityIndicatorWrapper: ActivityIndicatorProtocol {
    private let wrappedActivityIndicator: UIActivityIndicatorView

    init(activityIndicator: UIActivityIndicatorView) {
        self.wrappedActivityIndicator = activityIndicator
    }

    func startAnimating() {
        wrappedActivityIndicator.startAnimating()
    }

    func stopAnimating() {
        wrappedActivityIndicator.stopAnimating()
    }

    func isAnimating() -> Bool {
        return wrappedActivityIndicator.isAnimating
    }

    func showActivityIndicator() {
        DispatchQueue.main.async {
            self.wrappedActivityIndicator.startAnimating()
        }
    }

    func hideActivityIndicator() {
        DispatchQueue.main.async {
            self.wrappedActivityIndicator.stopAnimating()
        }
    }
}

