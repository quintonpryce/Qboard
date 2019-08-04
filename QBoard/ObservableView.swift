//
//  ObservableFrameView.swift
//  Keyboard
//
//  Created by Quinton Pryce on 2019-06-09.
//  Copyright © 2019 Quinton Pryce. All rights reserved.
//

// A modification of https://github.com/brynbodayle/BABFrameObservingInputAccessoryView
// Shoutout to Altai for some great work initially converting this to swift.
// https://github.com/altaibayar

import UIKit

class ObservableView: UIView {
    
    var onFrameChange: ((CGRect) -> Void)?
    
    private var centerObserver: NSKeyValueObservation?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        if let superviewFrame = superview?.frame {
            frame = superviewFrame
        }
        super.layoutSubviews()
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        if let newSuperview = newSuperview {
            var previousFrame = frame
            centerObserver = newSuperview.observe(\.center) { [weak self] _, _ in
                guard let strongSelf = self else { return }
                strongSelf.layoutSubviews()
                if previousFrame != strongSelf.frame {
                    strongSelf.onFrameChange?(strongSelf.frame)
                }
                previousFrame = strongSelf.frame
            }
        } else {
            centerObserver?.invalidate()
        }
        
        super.willMove(toSuperview: newSuperview)
    }
}
