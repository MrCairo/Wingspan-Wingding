//
//  ContentView.swift
//  Wingding
//
//  Created by Mitch Fisher on 2/25/25.
//

import SwiftUI

struct CardDeckInputView: View {
    @State var deckName: String = ""
    @State var deckCount: String = ""
    @State var showNumberAlert: Bool = false
    
    var body: some View {
        GeometryReader { geo in
            HStack {
                deckNameView
                    .frame(width: geo.size.width * 0.75, alignment: .leading)
                deckCountView
                    .frame(width: geo.size.width * 0.25, alignment: .trailing)
            }
        }
        .alert("# of cards can't exceed 200", isPresented: $showNumberAlert) {
            Button("OK", role: .cancel) { showNumberAlert = false }
        }
    }
    
    var deckNameView: some View {
        TextField("Deck Name",
                  text: $deckName)
        .onChange(of: deckName) { oldValue, newValue in
            if newValue.count > 25 {
                deckName = oldValue
            }
        }
        .textFieldStyle(RoundedBorderTextFieldStyle())
    }
    
    var deckCountView: some View {
        TextField("Count",
                  text: $deckCount)
        .onChange(of: deckCount) { oldValue, newValue in
            if !newValue.isNumber || newValue == "0" {
                deckCount = oldValue
            }
            if Int(newValue) ?? 0 > 200 {
                deckCount = oldValue
                showNumberAlert = true
            }
        }
        .textFieldStyle(RoundedBorderTextFieldStyle())
    }
}

extension String {
    var isNumber: Bool {
        let digitsCharacters = CharacterSet(charactersIn: "0123456789")
        return CharacterSet(charactersIn: self).isSubset(of: digitsCharacters)
    }
}

struct ContentView: View {
    
    var body: some View {
        NavigationStack {
            List {
                CardDeckInputView()
                CardDeckInputView()
                CardDeckInputView()
                CardDeckInputView()
                CardDeckInputView()
            }
        }
        .navigationTitle(Text("Card Deck Input"))
    }
}

