//
//  CardDeckHandler.swift
//  Wingding
//
//  Created by Mitch Fisher on 2/25/25.
//

///
/// **NOTE:**
/// This is an alternate way of managing decks of cards and pulling
/// random cards from all decks. This is similar to the `DeckHandler`
/// class.
///
///
import Foundation
import Combine

///
/// Represents a single card from a deck.
///
public struct Card {
    public private(set) var id: UUID = UUID()
    public private(set) var name: String?
    public private(set) var sourceDeck: String
    
    init(name: String? = nil, sourceDeck: String) {
        self.name = name
        self.sourceDeck = sourceDeck
    }
}

///
/// Represents a deck of cards.
/// - note: The **`cardsRemaining`** attribute of this object
///    can be observed so that when a card is drawn from
///    the deck, the observer will be notified.
///
public class Deck {
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

///
/// This class is used to manage the multiple decks of cards.
/// This includes randomizing all cards in all decks, removal
/// (or drawing) cards from the decks, and historical record
/// of the drawn cards.
///
public class DecksHandler {
    public private(set) var cardDrawHistory: [[CardDrawInfo]] = []
    public private(set) var allCards: [Card] = []
    public let decks: [Deck]
    
    public init(_ decks: [Deck]) {
        self.decks = decks
        self.decks.forEach { deck in
            self.allCards.append(Card(sourceDeck: deck.name))
        }
        
        self.allCards.shuffle()
    }

    ///
    /// Call this function to randomly draw `count` number of cards
    /// from a randomized set of decks. This spreads the draw randomly
    /// across all decks which simulates shuffling of all the decks
    /// together.
    ///
    public func drawCards(_ count: Int) -> [Card] {
        var drawnCards: [Card] = []
        var history: CardDrawInfo = [:]
        
        for _ in 0..<count {
            guard let cardToDraw = self.allCards.popLast() else {
                break
            }
            
            //
            // This makes it easier to track the remaining number of cards
            // left in a deck.
            //
            if let deck = decks.first(where: { $0.name == cardToDraw.sourceDeck }) {
                _ = removeCards(1, fromDeck: deck)
                let total = (history[deck.name] ?? 0) + 1
                history[deck.name] = total
            }

            drawnCards.append(cardToDraw)
        }

        self.cardDrawHistory.insert([history], at: 0)
        return drawnCards
    }
    
    //
    // Removes a number of cards from the specified deck. If there are
    // fewer cards than `count`, then all remaining cards are removed.
    // - returns: The number of cards actually removed.
    //
    private func removeCards(_ count: Int, fromDeck deck: Deck) -> Int { // Return how many cards removed
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
}
