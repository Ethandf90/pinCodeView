//
//  PinInputView.swift
//  PinInputView
//
//  Created by Fei Dong on 2017-07-31.
//  Copyright © 2017 Ethan Dong. All rights reserved.
//

import UIKit

struct pinViewConst {
    // for UI percentage
    static let width: CGFloat  = 0.1
    static let height: CGFloat = 0.08
    static let gap: CGFloat    = 0.05
}

protocol pinCodeViewDelegate {
    func pinInputView(view: PinInputView, didFinishWithCode code: String)
}

class PinInputView: UIView {

    var delegate: pinCodeViewDelegate?
    
    fileprivate var currentTag = 0
    fileprivate var firstTag = 0;
    fileprivate var lastTag = 0;
    
    fileprivate var lineViews: [UIView] = []
    
    convenience init(frame: CGRect, count: NSInteger) {
        self.init(frame: frame)
        
        // if count is 4, then first tag is 0, last tag is 3
        self.lastTag = count - 1;
        
        // x, y, width, height will be based on screen width/ height
        var labelFrame = Utility.percentageFrame(x: 0, y: 0, width: pinViewConst.width, height: pinViewConst.height)
        labelFrame.size.height = ceil(labelFrame.size.height)
        var lineFrame = Utility.percentageFrame(x: 0, y: pinViewConst.height - 0.003, width: pinViewConst.width, height: 0.003)
        
        for i in 0 ..< count {
            
            let digitLabel = UILabel(frame: labelFrame)
            digitLabel.font = UIFont.systemFont(ofSize: 40)
            digitLabel.backgroundColor = UIColor.white
            digitLabel.tag = i + 1000
            digitLabel.textAlignment = .center
            digitLabel.text = ""
            digitLabel.layer.borderColor = UIColor.white.cgColor
            digitLabel.layer.borderWidth = 1
            addSubview(digitLabel)
            labelFrame.origin.x += (pinViewConst.gap + pinViewConst.width) * UIScreen.main.bounds.size.width
            
            let lineView = UIView(frame: lineFrame)
            lineView.backgroundColor = UIColor.lightGray
            addSubview(lineView)
            lineViews.append(lineView)
            lineFrame.origin.x += (pinViewConst.gap + pinViewConst.width) * UIScreen.main.bounds.size.width
        }
        
        changeLineColor(ofIndex: 0)
    }
    
    fileprivate func changeLineColor(ofIndex: NSInteger) {
        var index = ofIndex
        lineViews.forEach { $0.backgroundColor = UIColor.lightGray}
        switch index {
        case self.lastTag + 1:
            index = self.lastTag
        case self.firstTag - 1:
            index = self.firstTag
        default:
            break
        }
        
        (lineViews[index] as UIView).backgroundColor = UIColor.darkGray
    }
    
    func onError() {
        lineViews.forEach { $0.backgroundColor = UIColor.red }
    }

    // MARK: - UIResponder
    public override var canBecomeFirstResponder: Bool {
        return true
    }


}

extension PinInputView: UIKeyInput {
    public var hasText: Bool {
        return currentTag > self.firstTag ? true : false
    }
    
    public func insertText(_ text: String) {
        if currentTag <= self.lastTag {
            (viewWithTag(currentTag + 1000)! as! UILabel).text = text
            currentTag += 1
            changeLineColor(ofIndex: currentTag)
            
            if currentTag > self.lastTag {
                var code = ""
                for index in self.firstTag ..< currentTag {
                    code += (viewWithTag(index + 1000)! as! UILabel).text!
                }
                delegate?.pinInputView(view: self, didFinishWithCode: code)
            }
        }
    }
    
    public func deleteBackward() {
        if currentTag > self.firstTag {
            currentTag -= 1
            
            (viewWithTag(currentTag + 1000)! as! UILabel).text = ""
            changeLineColor(ofIndex: currentTag)
        }
    }
    
    func clear() {
        while currentTag > self.firstTag {
            deleteBackward()
        }
    }
    
    // MARK: - UITextInputTraits
    public var keyboardType: UIKeyboardType { get { return .numberPad } set { } }
}


class Utility {
    
    static func percentageFrame(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> CGRect {
        return CGRect(x: relX(x),
                      y: relY(y),
                      width: relX(width),
                      height: relY(height))
    }
    
    static func relX(_ relativeX: CGFloat) -> CGFloat {
        return UIScreen.main.bounds.size.width * relativeX
    }
    
    static func relY(_ relativeY: CGFloat) -> CGFloat {
        return UIScreen.main.bounds.size.height * relativeY
    }
    
}
