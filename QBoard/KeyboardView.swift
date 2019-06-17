//
//  KeyboardView.swift
//  Keyboard
//
//  Created by Quinton Pryce on 2019-01-04.
//  Copyright © 2019 Quinton Pryce. All rights reserved.
//

import UIKit

/** Provides view that will follow the keyboard, interactively or not. This view should be added to the bottom of your view with
    a leading, trailing, and bottom constraint to either the superview or the safe area. The top constraint will need to be snapped
    to your textField or the very most bottom view. Ensure that the height constraint on this view is not required (ie. priority is not 1000). 
 */
class KeyboardView: UIView {
    
    /** Finds the textField in the superview automatically and sets it to be the view that follows the interactive keyboard.
     
    If you have multiple textFields in your view you will need to set this manually.
     
    Defaults to true.
     
    # Usage
    ```
    keyboardView.inputAccessoryView = myTextField.inputAccessoryView
    ```
     */
    @IBInspectable var autoSetup: Bool = true
    
    private var heightConstraint: NSLayoutConstraint?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addHeightConstraint()
        addKeyboardNotifications()
        
        if autoSetup { addInputAccessoryView() }
    }
    
    deinit {
        removeKeyboardNotifications()
    }
    
    private func addHeightConstraint() {
        let heightConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 0)
        heightConstraint.priority = .required
        addConstraint(heightConstraint)
        self.heightConstraint = heightConstraint
    }
    
    private func addInputAccessoryView() {
        if let textField = findTextField() {
            textField.inputAccessoryView = inputAccessoryView
        } else {
            assertionFailure("Could not find a textField in the superview. You will need to set the inputAccessoryView manually.")
        }
    }
    
    private func findTextField() -> UITextField? {
        let textField = superview?.subviews.first { (view) -> Bool in
            view as? UITextField != nil
        }
        
        return textField as? UITextField
    }
    
    public override var inputAccessoryView: UIView? {
        let observableAccessoryView = ObservableView(frame: frame)
        
        observableAccessoryView.onFrameChange = { observerFrame in
            let frameUpdateHeight = UIScreen.main.bounds.height - observerFrame.minY
            UIView.animate(withDuration: 0.0, animations: { [weak self] in
                self?.heightConstraint?.constant = frameUpdateHeight
            })
        }
        return observableAccessoryView
    }
}

// MARK: - OS Keyboard Methods
private extension KeyboardView {
    func addKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let keyboardSizeValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber else { return }
        let animationCurveRawNSN = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
        
        let keyboardHeight = keyboardSizeValue.cgRectValue.height
        
        UIView.animate(withDuration: duration.doubleValue, delay: 0, options: animationCurve, animations: { [weak self] in
            self?.heightConstraint?.constant = keyboardHeight
            self?.superview?.layoutIfNeeded()
        })
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber else { return }
        let animationCurveRawNSN = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
        
        UIView.animate(withDuration: duration.doubleValue, delay: 0, options: animationCurve, animations: { [weak self] in
            self?.heightConstraint?.constant = 0
            self?.superview?.layoutIfNeeded()
        })
    }
}
