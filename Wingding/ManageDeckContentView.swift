//
//  ContentView.swift
//  Wingding
//
//  Created by Mitch Fisher on 2/25/25.
//

import SwiftData
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

struct DeckInputModel {
    @State var deckName: String = ""
    @State var deckCount: String = ""
    @State private var showNumberAlert: Bool = false
    var readOnly: Bool = false
    
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

struct ManageDeckContentView: View {
    @Environment(\.modelContext) var viewContext
    @Query(sort: \Deck.name, order: .reverse) var deckList: [Deck]
    @State private var presentAdd: Bool = false
    @State private var presentEdit: Bool = false
    @State private var deckName: String = ""
    @State private var deckCount: String = "0"
    @State private var selected: Deck?
    
    var body: some View {
        NavigationStack {
            Section("Decks") {
                deckListView
            }
        }
        .navigationDestination(for: Deck.self) { deck in
            VStack {
                Label("\(deck.name), \(deck.totalCards) cards", systemImage: "folder")
            }
        }
    }

    func deckListRow(deck: Deck) -> some View {
        HStack {
            Text(deck.name)
            Spacer()
            Text("\(deck.totalCards) cards")
        }
    }
    
    var deckListView: some View {
        List {
            ForEach(deckList, id: \.name) { deck in
                NavigationLink(value: deck) {
                    deckListRow(deck: deck)
                }
            }
        }
    }
    
    var deckSheetButtons: some View {
        HStack {
            Button("Cancel", role: .cancel) {
                presentAdd = false
                presentEdit = false
            }
            Spacer()
            Button("Add") {
                if let deckCount = Int(deckCount),
                   deckName.isEmpty == false,
                   deckCount != 0 {
                    viewContext.insert(Deck(name: deckName, totalCards: deckCount))
                }
            }
        }
    }
    
    func sheetContentEditView(deck: Deck) -> some View {
        NavigationStack {
            Form {
                deckNameView()
                deckCountView
                deckSheetButtons
            }
            .navigationTitle(Text("Update Deck"))
        }
        .presentationDetents([.fraction(0.33)])
    }
    
    func sheetContentView() -> some View {
        NavigationStack {
            Form {
                deckNameView()
                deckCountView
                deckSheetButtons
            }
            .navigationTitle(Text("Add Deck"))
        }
        .presentationDetents([.fraction(0.33)])
    }
}


extension ManageDeckContentView {
    func deckNameView() -> some View {
        TextField("Deck Name",
                  text: $deckName)
        .onChange(of: deckName) { oldValue, newValue in
            if newValue.count > 25 {
                deckName = oldValue
            }
        }
        .textFieldStyle(RoundedBorderTextFieldStyle())
    }
    
    @ViewBuilder
    var deckCountView: some View {
        TextField("Number of Cards",
                  text: $deckCount)
        .onChange(of: deckCount) { oldValue, newValue in
            if !newValue.isNumber || newValue == "0" {
                deckCount = oldValue
            }
            if Int(newValue) ?? 0 > 200 {
                deckCount = oldValue
            }
        }
        .textFieldStyle(RoundedBorderTextFieldStyle())
        
    }
}

#Preview("Deck Manager") {
    ManageDeckContentView()
}
