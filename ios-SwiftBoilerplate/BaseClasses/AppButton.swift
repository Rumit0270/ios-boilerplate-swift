//
//  AppButton.swift
//  ios-SwiftBoilerplate
//
//  Created by Mac on 1/16/20.
//

import UIKit

class AppButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInitializer()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInitializer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInitializer()
    }
    
    private func commonInitializer() {
        setTitleColor(ColorConstants.appButtonTextColor, for: UIControl.State.normal)
        titleLabel?.font = UIFont.appFont(type: AppFont.bold, size: 13.0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //layer.cornerRadius = frame.size.width / 2
    }
    
}
