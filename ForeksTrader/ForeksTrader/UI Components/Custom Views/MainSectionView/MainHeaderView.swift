//
//  MainHeaderVFiew.swift
//  ForeksTrader
//
//  Created by Murat Can ASLAN on 9.01.2023.
//

import UIKit

typealias Action = () -> Void

class MainHeaderView: UIView {
        
    var leftAction: Action?
    
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        ownFirstNib()
        applyStyling()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        ownFirstNib()
        applyStyling()
    }
    
    private func applyStyling() {
        leftButton.layer.borderColor = UIColor.white.cgColor
        rightButton.layer.borderColor = UIColor.white.cgColor
        
        leftButton.layer.borderWidth = 1
        rightButton.layer.borderWidth = 1
        
        leftButton.layer.cornerRadius = 4
        rightButton.layer.cornerRadius = 4
        
    }
    
    func update(leftTitle: String) {
        leftButton.setTitle(leftTitle, for: .normal)
    }
    
    @IBAction func didTapLeft(_ sender: UIButton) {
        self.leftAction?()
    }
}

private extension UIView {
    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    func ownFirstNib() {
        let view = loadNib()
        view.frame = bounds
        view.autoresizingMask = [
            UIView.AutoresizingMask.flexibleWidth,
            UIView.AutoresizingMask.flexibleHeight
        ]
        addSubview(view)
        
    }
}

extension UIColor {
    static func dark() -> UIColor {
        .init(red: 41/255, green: 41/255, blue: 41/255, alpha: 1)
    }
}
