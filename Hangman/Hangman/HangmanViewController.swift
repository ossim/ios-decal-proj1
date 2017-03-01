//
//  GameViewController.swift
//  Hangman
//
//  Created by Shawn D'Souza on 3/3/16.
//  Copyright © 2016 Shawn D'Souza. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

class HangmanViewController: UIViewController {
    
    let alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    
    var mistakes = 1
    var pastLetters: [Character] = []
    var correctLetters: [Character] = []
    var selectedIndex: Int = -1
    var currPhrase = ""
    var currText = ""
    
    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var wrongLabel: UILabel!
    @IBOutlet weak var hangmanImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
        
    }
    
    func initialize() {
        mistakes = 1
        pastLetters = []
        correctLetters = []
        selectedIndex = -1
        currPhrase = ""
        currText = ""
        hangmanImage.image = UIImage.init(named: "hangman1")
        
        let hangmanPhrases = HangmanPhrases()
        
        currPhrase = hangmanPhrases.getRandomPhrase()
        print(currPhrase)
        
        currText = hangmanPhrases.getInitText(phrase: currPhrase)
        
        setText(newText: currText)
        correctLetters = hangmanPhrases.fillCorrectArray(phrase: currPhrase)
        
        wrongLabel.text = ""
        
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func restartButton(_ sender: UIBarButtonItem) {
        restart(alertMessage: "Restart Hangman")
    }
    
    @IBAction func LetterButton(_ sender: UIButton) {
        if (selectedIndex != -1) {
            let prev = self.view.viewWithTag(selectedIndex) as? UIButton
            prev?.backgroundColor = UIColor.init(netHex: 0xE2E2E2)
        }
        selectedIndex = sender.tag
        sender.backgroundColor = UIColor.lightGray
        print("Pressed " + alphabet.substring(atIndex: selectedIndex))
    }
    
    @IBAction func SubmitButton(_ sender: UIButton) {
        if (selectedIndex != -1) {
            let sel: Character = Character(alphabet.substring(atIndex: selectedIndex))
            print("Submit " + alphabet.substring(atIndex: selectedIndex))
            
            if pastLetters.contains(sel) {
                print("Already submitted " + alphabet.substring(atIndex: selectedIndex))
                
            } else if correctLetters.contains(sel) {
                currText = updateText(guess: sel, phrase: currPhrase, text: currText)
                
                print(currText + " is the new phrase")
                setText(newText: currText)
                
                print("validated correct guess " + alphabet.substring(atIndex: selectedIndex))

                
                pastLetters.append(sel)
                if let index = correctLetters.index(of: sel) {
                    correctLetters.remove(at: index)
                }
                
                if correctLetters.count == 0 {
                    restart(alertMessage: "You won!")
                }
                
            } else {
                mistakes += 1
                let filename = "hangman" + String(mistakes)
                hangmanImage.image = UIImage(named: filename)
                wrongLabel.text = wrongLabel.text! + alphabet.substring(atIndex: selectedIndex)
                print("Incorrect guess " + alphabet.substring(atIndex: selectedIndex))
                if (mistakes == 7) {
                    restart(alertMessage: "You lost!")
                }
            }
            
            let prev = self.view.viewWithTag(selectedIndex) as? UIButton
            prev?.backgroundColor = UIColor.init(netHex: 0xE2E2E2)
            selectedIndex = -1
        }
    }
    
    func setText(newText: String) {
        displayLabel.text = newText
    }
    
    func restart(alertMessage: String) {
        let alertController = UIAlertController(title: alertMessage, message: "Would you like to restart?", preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
            print("Cancel")
        }
        let okAction = UIAlertAction(title: "Restart", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                self.initialize()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
