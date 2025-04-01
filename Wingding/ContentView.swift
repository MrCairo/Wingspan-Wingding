//
//  ContentView.swift
//  Wingding
//
//  Created by Mitch Fisher on 2/25/25.
//

import SwiftUI

fileprivate struct DeckInfo: Identifiable, Equatable, Hashable {
    public var id: String {
        name
    }
    
    public var name: String
    public var count: Int
}

private class DeckListViewModel: ObservableObject {
    @Published var decks: [DeckInfo] = []
    
    fileprivate func addDeck(_ name: String, count: Int) {
        decks.append(.init(name: name, count: count))
        self.objectWillChange.send()
    }
}

struct CardDeckInputView: View {
    @State var deckName: String = ""
    @State var deckCount: String = ""
    @State var showNumberAlert: Bool = false
    private var readOnly: Bool = false
    
    fileprivate init(deck: DeckInfo, readOnly: Bool = false) {
        self.readOnly = readOnly
        self.deckName = deck.name
        self.deckCount = String(deck.count)
    }
    
    var body: some View {
        HStack {
            deckNameView
            deckCountView
        }
    }
    
    @ViewBuilder
    var deckNameView: some View {
        if !readOnly {
            TextField("Deck Name", text: $deckName, prompt: Text("Deck Name"))
                .onChange(of: deckName) { oldValue, newValue in
                    if newValue.count > 25 {
                        deckName = oldValue
                    }
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
        } else {
            Text(deckName)
        }
    }
    
    @ViewBuilder
    var deckCountView: some View {
        if !readOnly {
            TextField("Count", text: $deckCount, prompt: Text("# Cards"))
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
        } else {
            Text(deckCount)
        }
    }
}

extension String {
    var isNumber: Bool {
        let digitsCharacters = CharacterSet(charactersIn: "0123456789")
        return CharacterSet(charactersIn: self).isSubset(of: digitsCharacters)
    }
}

struct DeckListView: View {
    @StateObject fileprivate var viewModel: DeckListViewModel = .init()
    @State private var presentAddView: Bool = false
    @State var deckName: String = ""
    @State var deckCount: String = "0"
    
    static var previews: some View {
        Self()
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.decks) { deck in
                    HStack {
                        Text(deck.name)
                        Spacer()
                        Text("\(deck.count) cards")
                    }
                }
            }
            .navigationTitle(Text("Card Deck Input"))
            .sheet(isPresented: $presentAddView) {
                NavigationStack {
                    Form {
//                        deckNameView
//                        deckCountView
                        HStack {
                            Button("Cancel") {
                                presentAddView = false
                            }
                            Spacer()
                            Button("Add") {
                                if let deckCount = Int(deckCount), deckName.isEmpty == false, deckCount != 0 {
                                    viewModel.addDeck(deckName, count: deckCount)
                                }
                            }
                        }
                    }
                }
                .presentationDetents([.fraction(1.0/3.0)])
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        presentAddView = true
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                    }
                }
            }
        }
    }
}

struct ContentView: View {
    
    @ViewBuilder
    var body: some View {
        NavigationStack {
            NavigationLink("Add Deck Information") {
                DeckListView()
            }
        }
    }
}
