//
//  Encryption.swift
//  mkwChat
//
//  Created by Matt Wilfert on 4/21/16.
//  Copyright © 2016 Matt Wilfert. All rights reserved.
//

import Foundation
import CryptoSwift


public class Encryption{

    
    func encrypt(message: String, key: String, option: String) -> String{
        
        var temp = "";
        
        if option == "Clear text"{
            return message
        }
        
        if option == "Caesar Cypher" {
            return caesarCypher(message, key: key)
        }
        
        if option == "Base64"{
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                temp = self.Base64(message, key: key)
                })
            return temp;

        }
        
        return "null"
        
    }
    
    func decrypt(message: String, key: String, option: String) -> String{
        
        
        if option == "Clear text"{
            return message
        }
        
        if option == "Caesar Cypher" {
            return caesarCypherDecrypt(message, key: key)
        }
        
        if option == "Base64"{
            return Base64Decrypt(message, key: key)
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
        var temp:UInt32
        
        print(97 + difference)
        
        var newText = ""
        
        for uni in message.unicodeScalars {
            var val = uni.value
            if uni >= "A" && uni <= "Z" {
                val += difference
                temp = val % 65
                val = temp + 65
            }
            
            if uni >= "a" && uni <= "z" {
                val += difference
                temp = val % 97
                val = temp + 97
            }
            print("newText:"+newText)
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
        var temp:UInt32
        
        print(97 + difference)
        
        var newText = ""
        
        for uni in message.unicodeScalars {
            var val = uni.value
            if uni >= "A" && uni <= "Z" {
                val -= difference
                if val < 65{
                    val = 90 - (64 - val)
                }
            }
            
            if uni >= "a" && uni <= "z" {
                val -= difference
                if val < 97{
                    val = 122 - (96 - val)
                }
            }
            newText.append(UnicodeScalar(val))
        }
        
        print(newText)
        return newText
        
    }
    
    func Base64(message: String, key: String) -> String {
        
        var temp = key

        
        while temp.characters.count < 16{
            temp += "0"
        }
        
        let base64String = try! message.encrypt(AES(key: temp, iv: "0123456789012345")).toBase64()
        
        return base64String!
        
    }
    
    func Base64Decrypt(message: String, key: String) -> String {
        
        var temp = key
        
        while temp.characters.count < 16{
            temp += "0"
        }
        
        var decrypted: String?
        
        //why is this not working
            decrypted = try! message.decryptBase64ToString(AES(key: temp, iv: "0123456789012345"))
        
        return decrypted!
    }
    
    func test(){
        print("hi");
    }
    

    
}