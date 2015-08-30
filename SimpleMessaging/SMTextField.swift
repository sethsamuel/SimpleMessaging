//
//  SMTextField
//  SimpleMessaging
//
//  Created by Seth on 8/30/15.
//  Copyright (c) 2015 Seth Samuel. All rights reserved.
//

import UIKit

class SMTextField : UITextField {
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return super.textRectForBounds(UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(6, 6, 6, 6)))
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return self.textRectForBounds(bounds)
    }
}
