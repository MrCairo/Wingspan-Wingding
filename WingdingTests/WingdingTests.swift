//
//  WingdingTests.swift
//  WingdingTests
//
//  Created by Mitch Fisher on 2/9/25.
//

import Testing
@testable import Wingding

struct WingdingTests {
    
    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }
    
    @Test func deckRandomness() async throws {
        let decks: [DeckOfCards] = [
            DeckOfCards("North American Birds", totalCards: 50),
            DeckOfCards("European Expansion" , totalCards: 50),
            DeckOfCards("Oceania Expansion", totalCards: 50)
        ]
        let handler = CardWingdingsHandler(decks)
        
        for _ in 0..<7 {
            handler.drawCardsFromAllDecks(5)
        }
    }
    
    @Test func testDrawingCards() async throws {
        let decks: [DeckOfCards] = [
//            DeckOfCards("North American Birds", totalCards: 171),
//            DeckOfCards("European Expansion" , totalCards: 81),
//            DeckOfCards("Oceania Expansion", totalCards: 95)
            DeckOfCards("North American Birds", totalCards: 22),
            DeckOfCards("European Expansion" , totalCards: 21),
            DeckOfCards("Oceania Expansion", totalCards: 20)
        ]
        let handler = CardWingdingsHandler(decks)
        
        handler.decks.forEach { print("\($0.deckName): \($0.cardsRemaining)") }
        for _ in 0..<5 {
            let x = handler.drawCardsFromAllDecks(5)
            x.forEach { deckWithCount in
                let padded = deckWithCount.deckName.padding(toLength: 25,withPad: " ", startingAt: 0)
                if deckWithCount.drawCount > 0 {
                    print("From \(padded) draw \(deckWithCount.drawCount) cards.")
                    
                }
            }
            print("-----------------------------------------")
            handler.decks.forEach { print("\($0.deckName), Cards Remaining: \($0.cardsRemaining)") }
            print("********************************************\n\n")
        }
        
        handler.decks.forEach { print("\($0.deckName): \($0.cardsRemaining)") }
    }
}
