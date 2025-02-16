//
//  DeckHandlingModel.swift
//  Wingding
//
//  Created by Mitch Fisher on 2/9/25.
//

import OrderedCollections

public class DeckOfCards {
    public private(set) var deckName: String
    public private(set) var totalCards: Int
    // An array of card inde values
    private var randomized: [Int] = []
    
    init(_ deckName: String, totalCards: Int) {
        self.deckName = deckName
        self.totalCards = totalCards
        self.randomized = Array(1...totalCards).shuffled()
    }
    
    public var cardsRemaining: Int {
        return randomized.count
    }
    
    public func removeCards(_ count: Int) -> Int { // Return how many cards removed
        guard count > 0 && count <= totalCards else { return 0 }
        // I define this variable so it's clear what's being returned.
        // It could easily be `count` or something else but it makes it
        // easier to undertand at least.
        var numberOfCardsRemoved = count

        if count <= randomized.count {
            randomized.removeSubrange(0..<count)
        } else {
            numberOfCardsRemoved = randomized.count
            randomized.removeAll()
        }
        return numberOfCardsRemoved
    }
}

///
/// Used to track a deck and how many cards to draw
/// So, if 5 cards are to be drawn from two different decks,
/// this would represent one of those decks with 1-5 cards
/// to be drawn. The sum of all of these DecWithCount structs
/// should equal 5 (in this case).
///
public struct DeckWithCount {
    var deckName: String
    var drawCount: Int
}

///
/// This is the main class that is used to manage all decks,
/// remove a given hand, maintain, the remaining card totals
/// for each deck and finally to keep a history of all the
/// hands drawn.
///
public class CardWingdingsHandler {
    public private(set) var cardDrawHistory: [[DeckWithCount]] = []
    public let decks: [DeckOfCards]

    required init(_ decksToManage: [DeckOfCards]) {
        self.decks = decksToManage
    }
    
    ///
    /// Call this function to randomly draw `count` number of cards
    /// from a randomized set of decks. This spreads the draw randomly
    /// across all decks which simulates shuffling of all the decks
    /// together.
    ///
    @discardableResult
    public func drawCardsFromAllDecks(_ count: Int) -> [DeckWithCount] {
        var cardsDrawn: [DeckWithCount] = []
        
        guard decks.count > 0 else {
            addToHistory([DeckWithCount(deckName: "", drawCount: 0)]) // This shouldn't happen but here it is in case
            return []
        }

        //
        // Create an empty set of cardsDrawn for each deck.
        //
        decks.forEach { cardsDrawn.append(DeckWithCount(deckName: $0.deckName,
                                                        drawCount: 0)) }
        
        for _ in 0..<count {
            // Get one random deck from the array of decks
            if let element: DeckOfCards = decks.randomElement() {
                // For the random deck, find it in the `cardsDrawn` array
                guard let itemIndex = cardsDrawn.firstIndex(where: { $0.deckName == element.deckName }) else {
                    continue
                }
                let deckCounter = cardsDrawn[itemIndex]
                let total = deckCounter.drawCount + 1
                cardsDrawn[itemIndex] = DeckWithCount(deckName: deckCounter.deckName,
                                                      drawCount: total)
                _ = element.removeCards(1)
            }
        }

        return cardsDrawn
    }
    
    private func addToHistory(_ drawCounts: [DeckWithCount]) {
        cardDrawHistory.insert(drawCounts, at: 0)
    }
}
