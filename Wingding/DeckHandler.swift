//
//  DeckHandlingModel.swift
//  Wingding
//
//  Created by Mitch Fisher on 2/9/25.
//

import Foundation
import Combine
import OrderedCollections


///
/// Represents a deck of cards.
/// - note: The **`cardsRemaining`** attribute of this object
///    can be observed so that when a card is drawn from
///    the deck, the observer will be notified.
///
public class DeckOfCards {
    public fileprivate(set) var name: String
    public fileprivate(set) var totalCards: Int
    /// As cards are drawn from the deck, this value represents
    /// the total amount of cards remaining in the deck.
    @Published public fileprivate(set) var cardsRemaining: Int
    // An array of card inde values
    fileprivate var randomizedCards: [Int] = []

    public init(name: String, totalCards: Int) {
        self.name = name
        self.totalCards = totalCards
        self.randomizedCards = Array(1...totalCards).shuffled()
        self.cardsRemaining = totalCards
    }
}


public typealias CardDrawInfo = Dictionary<String, Int>

///
/// This class is used to manage the multiple decks of cards.
/// This includes randomizing all cards in all decks, removal
/// (or drawing) cards from the decks, and historical record
/// of the drawn cards.
///
public class DeckHandler {
    public private(set) var cardDrawHistory: [[CardDrawInfo]] = []
    public let decks: [DeckOfCards]

    required init(_ decksToManage: [DeckOfCards]) {
        self.decks = decksToManage
        self.shuffleDecks()
    }
    
    ///
    /// Call this function to randomly draw `count` number of cards
    /// from a randomized set of decks. This spreads the draw randomly
    /// across all decks which simulates shuffling of all the decks
    /// together.
    ///
    @discardableResult
    public func drawCardsFromAllDecks(_ count: Int) -> [String: Int] {
        var pulled: CardDrawInfo = [:]

        for _ in 0..<count {
            // Get one random deck from the array of decks.
            // drawCard() takes into account decks with more cards than others.
            if let whichDeck: DeckOfCards = drawCard() {
                let total = (pulled[whichDeck.name] ?? 0) + 1
                pulled[whichDeck.name] = total
                _ = removeCards(1, fromDeck: whichDeck)
            }
        }

        return pulled
    }
    
    public func removeCards(_ count: Int, fromDeck deck: DeckOfCards) -> Int { // Return how many cards removed
        guard count > 0 && count <= deck.totalCards else { return 0 }
        // I define this variable so it's clear what's being returned.
        // It could easily be `count` or something else but it makes it
        // easier to undertand at least.
        var numberOfCardsRemoved = count

        if count <= deck.randomizedCards.count {
            deck.randomizedCards.removeSubrange(0..<count)
        } else {
            numberOfCardsRemoved = deck.randomizedCards.count
            deck.randomizedCards.removeAll()
        }
        deck.cardsRemaining = deck.randomizedCards.count
        return numberOfCardsRemoved
    }

    //MARK: - Private methods
    //
    // Shuffle all card decks
    //
    private func shuffleDecks() {
        self.decks.forEach { $0.randomizedCards = Array(1...$0.totalCards).shuffled() }
    }
    
    //
    // Append the draw count information to history.
    //
    private func addToHistory(_ drawCounts: [CardDrawInfo]) {
        cardDrawHistory.insert(drawCounts, at: 0)
    }
    
    //
    // Since some decks may be larger than others, the likelyhood of
    // choosing a card from the deck with the largest number of cards
    // is more likely. This will randomly choose a card from all the
    // cards of all the decks and return the deck of that card.
    //
    private func drawCard() -> DeckOfCards? {
        let totalCards = decks.reduce(0) { $0 + $1.cardsRemaining }
        var cardSets: [Range<Int>] = []
        
        var runningCardCount = 0
      
        //
        // cardSets represent a range of cards for a specific deck of cards.
        //
        decks.forEach { deck in
            if deck.cardsRemaining > 0 {
                cardSets.append(Range(runningCardCount...(runningCardCount + deck.cardsRemaining - 1)))
                runningCardCount += deck.cardsRemaining
            }
        }
        
        let pick = Int.random(in: 0..<totalCards)
        if let whichDeck = cardSets.firstIndex(where: { $0.contains(pick) }) {
            return decks[whichDeck]
        }
        
        return nil
    }
}
