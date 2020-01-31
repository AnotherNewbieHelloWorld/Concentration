//
//  ViewController.swift
//  Concentration
//
//  Created by Apple User on 29.01.2020.
//  Copyright © 2020 Alena Khoroshilova. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var cardButtons: [UIButton]!
    @IBOutlet weak var flipCountLabel: UILabel!
    
    lazy var game: Concentration = {
        return Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
    }()
    
    var flipCount = 0 {
        didSet {
            flipCountLabel.text = "Flips: \(flipCount)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
    }
    
    @IBAction func touchButton(_ sender: UIButton) {
        flipCount += 1
        guard let cardNumber = cardButtons.lastIndex(of: sender) else {
            print("chosen card was not incardButton.")
            return
        }
        game.chooseCard(at: cardNumber)
        updateViewFromModel()
    }
    
    @IBAction func startNewGame(_ sender: UIButton) {
        flipCount = 0
        game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
        setTheme()
        
        for index in cardButtons.indices {
            cardButtons[index].setTitle("", for: UIControl.State.normal)
            cardButtons[index].backgroundColor = #colorLiteral(red: 1, green: 0.6235294118, blue: 0.03921568627, alpha: 1)
        }
        updateViewFromModel()
    }
    
    func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.6235294118, blue: 0.03921568627, alpha: 0) : #colorLiteral(red: 1, green: 0.6235294118, blue: 0.03921568627, alpha: 1)
            }
        }
    }
    var emojiChoicesThemes = [0: ["🦇","😱","🙀","😈","🎃","👻","🍭","🍬","🍎"],
                        1: ["🍒","🥭","🥥","🍍","🥝","🍋","🍉","🍑","🍓"],
                        2: ["🥐","🥯","🥨","🥖","🧇","🍞","🥞","🥟","🥧"],
                        3: ["🍾","🥳","💃","🕺","🎂","🍹","🥂","🎊","🎉"],
                        4: ["⚽️","🏀","🏈","⚾️","🥎","🎾","🏐","🏉","🎱"],
                        5: ["🍆","🥑","🥦","🌽","🥕","🧄","🌶","🍅","🧅"],
                        6: ["🛋","🪑","🚪","🚽","🛏","🧸","🧺","🛁","🧹"]]
    
    var emoji = [Int:String]()
    var themeNumber = 0
    var emojiChoices = [String]()
    
    func setTheme() {
        themeNumber = Int(arc4random_uniform(UInt32(emojiChoicesThemes.keys.count)))
        emojiChoices = emojiChoicesThemes[themeNumber] ?? ["?"]
    }
    
    func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil, emojiChoices.count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count)))
            emoji[card.identifier] = emojiChoices.remove(at: randomIndex)
        } 
        return  emoji[card.identifier] ?? "?"
    }
}

