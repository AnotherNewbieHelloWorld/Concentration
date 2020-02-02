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
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var flipCountLabel: UILabel!
    
    lazy var game: Concentration = {
        return Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
    }()
    
    var flipCount = 0 {
        didSet {
            flipCountLabel.text = "Flips: \(flipCount)"
        }
    }
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
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
        score += game.chooseCard(at: cardNumber)
        updateViewFromModel()
    }
    
    @IBAction func startNewGame(_ sender: UIButton) {
        flipCount = 0
        score = 0
        game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
        setTheme()
        
        for index in cardButtons.indices {
            cardButtons[index].setTitle("", for: UIControl.State.normal)
            cardButtons[index].backgroundColor = colorTheme[1]
        }
        updateViewFromModel()
    }
    
    func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? colorTheme[0] : colorTheme[1]
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
    
    var viewThemes = [0: [#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),#colorLiteral(red: 1, green: 0.6235294118, blue: 0.03921568627, alpha: 1)], 1: [#colorLiteral(red: 0.4392156899, green: 0.3372549117, blue: 0.4392156899, alpha: 1),#colorLiteral(red: 0.9882352941, green: 0.7215686275, blue: 0.1529411765, alpha: 1)], 2: [#colorLiteral(red: 1, green: 0.8361050487, blue: 0.6631416678, alpha: 1),#colorLiteral(red: 0.843980968, green: 0.4811213613, blue: 0.2574525177, alpha: 1)], 3: [#colorLiteral(red: 1, green: 0.6872233152, blue: 1, alpha: 1),#colorLiteral(red: 0.4814628959, green: 0.09981138259, blue: 0.4759578705, alpha: 1)], 4: [#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 0.6516778469, green: 0.9803054929, blue: 0, alpha: 1)], 5: [#colorLiteral(red: 0.4607669711, green: 0.8235028386, blue: 0.4748512506, alpha: 1),#colorLiteral(red: 0.4814628959, green: 0.09981138259, blue: 0.4759578705, alpha: 1)], 6: [#colorLiteral(red: 0.6648116708, green: 0.6787632704, blue: 1, alpha: 1),#colorLiteral(red: 0.0009274088661, green: 0.02324046195, blue: 0.2609408498, alpha: 1)]]
    // fruits balls
    var emoji = [Int:String]()
    var themeNumber = 0
    var emojiChoices = [String]()
    var colorTheme = [#colorLiteral(red: 1, green: 0.6235294118, blue: 0.03921568627, alpha: 1),#colorLiteral(red: 1, green: 0.6235294118, blue: 0.03921568627, alpha: 1)]
    
    func setTheme() {
        themeNumber = Int(arc4random_uniform(UInt32(emojiChoicesThemes.keys.count)))
        emojiChoices = emojiChoicesThemes[themeNumber] ?? ["?"]
        colorTheme = viewThemes[themeNumber] ?? [#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.1568113565, blue: 0.2567096651, alpha: 1)]
        view.backgroundColor = colorTheme[0]
        for index in cardButtons.indices {
            cardButtons[index].setTitle("", for: UIControl.State.normal)
            cardButtons[index].backgroundColor = colorTheme[1]
        }
    }
    
    func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil, emojiChoices.count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count)))
            emoji[card.identifier] = emojiChoices.remove(at: randomIndex)
        } 
        return  emoji[card.identifier] ?? "?"
    }
}

