//
//  String+SimpleMessaging.swift
//  SimpleMessaging
//
//  Created by Seth on 9/5/15.
//  Copyright (c) 2015 Seth Samuel. All rights reserved.
//

import Foundation

//http://stackoverflow.com/questions/24123518/how-to-use-cc-md5-method-in-swift-language
extension String  {
    var md5: String! {
        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let strLen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
        
        CC_MD5(str!, strLen, result)
        
        var hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        
        result.dealloc(digestLen)
        
        return String(format: hash as String)
    }
}