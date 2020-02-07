//
//  Concentration.swift
//  Concentration
//
//  Created by Apple User on 31.01.2020.
//  Copyright © 2020 Alena Khoroshilova. All rights reserved.
//

import Foundation

struct Concentration {
    
    // API is how you use this class
    
    // "private(set) var" for peaple other than me it's almost like a "let"
    // outside people can't modify it
    private(set) var cards = [Card]()
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            //let ch = "hello".oneAndOnly // return nil
            //let ch = "h".oneAndOnly // return "h"
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
         }
        set (newValue) {
            // turn all the cards face down except the card at index newValue
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    mutating func chooseCard(at index: Int) -> Int {
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in the cards")
        var points = 0
        if cards[index].beenSeen {
            points = -1
        }
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                // check if cards match
                if cards[matchIndex] == cards[index] {
                    points = 2
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                cards[index].isFaceUp = true
            } else {
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
        cards[index].beenSeen = true
        return points
    }
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "Concentration.init(at: \(numberOfPairsOfCards)): you must have at least one pair of cards")
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        cards.shuffle()
    }
}

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
