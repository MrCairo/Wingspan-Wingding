//
//  ContentView.swift
//  Wingding
//
//  Created by Mitch Fisher on 2/9/25.
//

import SwiftUI

enum CardChoice: String, CaseIterable, Identifiable {
    var id: Self { self }
    
    case oneCard = "One"
    case twoCards = "Two"
    case threeCards = "Three"
    case fourCards = "Four"
    case fiveCards = "Five"
}

extension CardChoice {
    var resourceName: String {
        switch self {
        case .oneCard: return "1-card-down"
        case .twoCards: return "2-cards-down"
        case .threeCards: return "3-cards-down"
        case .fourCards: return "4-cards-down"
        case .fiveCards: return "5-cards-down"
        }
    }
    
    var howManyCards: Int {
        switch self {
        case .oneCard: return 1
        case .twoCards: return 2
        case .threeCards: return 3
        case .fourCards: return 4
        case .fiveCards: return 5
        }
    }
}


struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink {
                    CardSelectionView()
                } label: {
                    Text("Select A Card")
                }
            }
        }
    }
}

struct CardSelectionView: View {
    @State var selectedCard: CardChoice = .oneCard
    
    var body: some View {
        VStack {
            Text("Select the number of cards to draw:")
            Text("Selected card is \(selectedCard.howManyCards)")
        }
        .padding()
        cardPicker()
            .pickerStyle(.menu)
    }
    
    func cardPicker() -> some View {
        Picker("Cards", selection: $selectedCard) {
            ForEach(CardChoice.allCases, id: \.self) { card in
                HStack(alignment: .center, spacing: 5.0) {
                    Image(card.resourceName)
                    //                        .resizable()
                    //                        .aspectRatio(contentMode: .fit)
                    //                        .scaleEffect(0.75)
                    Spacer()
                    Text(card.rawValue)
                }
                .tag(card)
            }
        }
    }
}

#Preview {
    ContentView()
}
