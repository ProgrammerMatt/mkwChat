//
//  Encryption.swift
//  mkwChat
//
//  Created by Matt Wilfert on 4/21/16.
//  Copyright © 2016 Matt Wilfert. All rights reserved.
//

import Foundation

public class Encryption{

    
    func encrypt(message: String, key: String, option: String) -> String{
        
        
        if option == "Clear text"{
            return message
        }
        
        if option == "Caesar Cypher" {
            return caesarCypher(message, key: key)
        }
        
        if option == "SHA256"{
            return SHA256(message, key: key)
        }
        
        return "null"
        
    }

    func caesarCypher(message: String, key: String) -> String {
    
        if key.characters.count != 1{
            print("key needs to be 1 character for caeser cypher")
            return "no"
        }
        
        var lowerCaseKey = key.lowercaseString
        var singleCharString = lowerCaseKey as NSString
        var singleCharValue = singleCharString.characterAtIndex(0)
        
        var difference = UInt32(singleCharValue - 97)
        
        print(97 + difference)
        
        var newText = ""
        
        for uni in message.unicodeScalars {
            var val = uni.value
            if uni >= "A" && uni <= "z" {
                val += difference
            }
            newText.append(UnicodeScalar(val))
        }
        
       return newText
        
    }
    
    func caesarCypherDecrypt(message: String, key: String) -> String {
        
        if key.characters.count != 1{
            print("key needs to be 1 character for caeser cypher")
            return "no"
        }
        
        var lowerCaseKey = key.lowercaseString
        var singleCharString = lowerCaseKey as NSString
        var singleCharValue = singleCharString.characterAtIndex(0)
        
        var difference = UInt32(singleCharValue - 97)
        
        print(97 + difference)
        
        var newText = ""
        
        for uni in message.unicodeScalars {
            var val = uni.value
            if uni >= "A" && uni <= "z" {
                val -= difference
            }
            newText.append(UnicodeScalar(val))
        }
        
        print(newText)
        return newText
        
    }
    
    func SHA256(message: String, key: String) -> String {
        
        return "needtodo"
    }
    
}