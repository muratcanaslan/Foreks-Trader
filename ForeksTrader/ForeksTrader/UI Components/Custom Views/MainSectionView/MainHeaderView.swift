//
//  MainHeaderVFiew.swift
//  ForeksTrader
//
//  Created by Murat Can ASLAN on 9.01.2023.
//

import UIKit

class MainHeaderView: UIView {
    
    @IBOutlet weak var leftMenuButton: UIButton!
    @IBOutlet weak var rightMenuButton: UIButton!
    
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
        leftMenuButton.layer.borderColor = UIColor.white.cgColor
        rightMenuButton.layer.borderColor = UIColor.white.cgColor
        
        leftMenuButton.layer.borderWidth = 1
        rightMenuButton.layer.borderWidth = 1
        
        leftMenuButton.layer.cornerRadius = 4
        rightMenuButton.layer.cornerRadius = 4
        
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
