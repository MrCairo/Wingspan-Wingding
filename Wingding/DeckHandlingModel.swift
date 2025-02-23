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
    private var randomizedCards: [Int] = []
    
    init(_ deckName: String, totalCards: Int) {
        self.deckName = deckName
        self.totalCards = totalCards
        self.randomizedCards = Array(1...totalCards).shuffled()
    }
    
    public var cardsRemaining: Int {
        return randomizedCards.count
    }
    
    public func removeCards(_ count: Int) -> Int { // Return how many cards removed
        guard count > 0 && count <= totalCards else { return 0 }
        // I define this variable so it's clear what's being returned.
        // It could easily be `count` or something else but it makes it
        // easier to undertand at least.
        var numberOfCardsRemoved = count

        if count <= randomizedCards.count {
            randomizedCards.removeSubrange(0..<count)
        } else {
            numberOfCardsRemoved = randomizedCards.count
            randomizedCards.removeAll()
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
        
        let sortedDecks = decks.sorted { $0.cardsRemaining > $1.cardsRemaining }
        
        sortedDecks.forEach { print("Ranked: \($0.deckName)") }
        //
        // Create an empty set of cardsDrawn for each deck.
        //
        decks.forEach { cardsDrawn.append(DeckWithCount(deckName: $0.deckName,
                                                        drawCount: 0)) }
                
        for _ in 0..<count {
            // Get one random deck from the array of decks.
            // Used to do decks.randomElement() which would just pick a deck
            // without consideration that the deck may have more cards than other
            // decks. getDeckFromRandomizedCards() takes into account decks with
            // more cards than others.
            if let whichDeck: DeckOfCards = getDeckFromRandomizedCards() {
                // For the random deck, find it in the `cardsDrawn` array
                guard let itemIndex = cardsDrawn.firstIndex(where: { $0.deckName == whichDeck.deckName }) else {
                    continue
                }
                let deckCounter = cardsDrawn[itemIndex]
                let total = deckCounter.drawCount + 1
                cardsDrawn[itemIndex] = DeckWithCount(deckName: deckCounter.deckName,
                                                      drawCount: total)
                _ = whichDeck.removeCards(1)
            }
        }

        return cardsDrawn
    }
    
    private func addToHistory(_ drawCounts: [DeckWithCount]) {
        cardDrawHistory.insert(drawCounts, at: 0)
    }

    //
    // Since some decks may be larger than others, the likelyhood of
    // choosing a card from the deck with the largest number of cards
    // is more likely. This will randomly choose a card from all the
    // cards of all the decks and return the deck of that card.
    //
    private func getDeckFromRandomizedCards() -> DeckOfCards? {
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
        
//        if runningCardCount != totalCards {
//            fatalError()
//        }
        
        let pick = Int.random(in: 0..<totalCards)
        if let whichDeck = cardSets.firstIndex(where: { $0.contains(pick) }) {
            return decks[whichDeck]
        }
        
        return nil
    }
}
