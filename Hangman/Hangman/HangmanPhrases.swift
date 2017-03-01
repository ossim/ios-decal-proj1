//
//  HangmanPhrases.swift
//  Hangman
//
//  Created by Shawn D'Souza on 3/3/16.
//  Copyright © 2016 Shawn D'Souza. All rights reserved.
//

import Foundation

class HangmanPhrases {
    
    var phrases : NSArray!
    
    // Initialize HangmanPhrase with an array of all possible phrases of the Hangman game
    init() {
        let path = Bundle.main.path(forResource: "phrases", ofType: "plist")
        phrases = NSArray.init(contentsOfFile: path!)
    }
    
    // Get random phrase from all available phrases
    func getRandomPhrase() -> String {
        let index = Int(arc4random_uniform(UInt32(phrases.count)))
        return phrases.object(at: index) as! String
    }
    
    func getInitText(phrase: String) -> String {
        var text: String = ""
        for i in phrase.characters {
            if (i != " ") {
                text = text + "_"
            } else {
                text = text + " "
            }
        }
        return text
    }
    
    func fillCorrectArray(phrase: String) -> [Character] {
        var correctArray: [Character] = []
        for i in phrase.characters {
            if (i != " " && !correctArray.contains(i)) {
                correctArray.append(i)
            }
        }
        return correctArray
    }
}

func replace(myString: String, index: Int, newChar: Character) -> String {
    
//    let len = myString.characters.count
    
    var newString = myString
    
    let strindex = myString.index(myString.startIndex, offsetBy: index)
    let strindex2 = myString.index(myString.startIndex, offsetBy: index + 1)
    
    newString = myString.substring(to: strindex) + String(newChar) + myString.substring(from: strindex2)
    
//    var modifiedString = String()
//    for (i, char) in myString.characters.enumerated() {
//        modifiedString += String((i == index) ? newChar : char)
//    }
//    return modifiedString
    
    return newString
}


func updateText(guess: Character, phrase: String, text: String) -> String {
    var newText = text
    print("before beginning, we have " + newText)
    
    var n = 0
    
    for i in phrase.characters {
        print("check char " + String(i) + " is it guess " + String(guess))
        if (i == guess) {
            newText = replace(myString: newText, index: n, newChar: guess)
            print(" yes, it is, new is " + newText)
        }
        n += 1
    }
    
    return newText
}

