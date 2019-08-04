//
//  ViewController.swift
//  Keyboard
//
//  Created by Quinton Pryce on 2019-01-04.
//  Copyright © 2019 Quinton Pryce. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var keyboardView: KeyboardView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeTapToDismiss()
        scrollView.keyboardDismissMode = .interactive
        scrollView.contentSize = contentView.frame.size
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
        
        // Optional manual setting of the inputAccessoryView.
//        textField.inputAccessoryView = keyboardView.inputAccessoryView
        
    }
}

// MARK: Keyboard dismissal on tap
extension UIViewController {
    /// Initializes the tap to dismiss on this view controller.
    func initializeTapToDismiss() {
        let tap: UITapGestureRecognizer = .init(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

