//
//  Concentration.swift
//  Concentration
//
//  Created by Apple User on 31.01.2020.
//  Copyright © 2020 Alena Khoroshilova. All rights reserved.
//

import Foundation

class Concentration {
    
    // API is how you use this class
    var cards = [Card]()
    var indexOfOneAndOnlyFaceUpCard: Int?
    
    func chooseCard(at index: Int) -> Int {
        var points = 0
        if cards[index].beenSeen {
            points = -1
        }
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                // check if cards match
                if cards[matchIndex].identifier == cards[index].identifier {
                    points = 2
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = nil
            } else {
                // either no cards or two cardsare face up
                for flipDownIndex in cards.indices {
                    cards[flipDownIndex].isFaceUp = false
                }
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
        cards[index].beenSeen = true
        return points
    }
    
    init(numberOfPairsOfCards: Int) {
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        // TODO: Shuffle the cards + add a "new game" button
        cards.shuffle()
    }
}
