//
//  ContentView.swift
//  Crossword2
//
//  Created by CSUFTitan on 5/8/20.
//  Copyright © 2020 Richard Phan. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    var keyboard = [
        ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"],
        ["A", "S", "D", "F", "G", "H", "J", "K", "L"],
        ["Z", "X", "C", "V", "B", "N", "M"]
    ]
    
    var words: [[String]] = [
        ["D", "O", "O", "R", ".", ".", "."],
        [".", "P", ".", ".", ".", "W", "."],
        [".", "E", ".", ".", ".", "A", "."],
        [".", "N", "U", "T", ".", "T", "."],
        [".", "I", ".", "E", "V", "E", "N"],
        [".", "N", ".", "N", ".", "R", "."],
        [".", "G", ".", ".", ".", ".", "."]
    ]
    
    @State var inputs: [[String]] = [
        [" ", " ", " ", " ", ".", ".", "."],
        [".", " ", ".", ".", ".", " ", "."],
        [".", " ", ".", ".", ".", " ", "."],
        [".", " ", " ", " ", ".", " ", "."],
        [".", " ", ".", " ", " ", " ", " "],
        [".", " ", ".", " ", ".", " ", "."],
        [".", " ", ".", ".", ".", ".", "."]
    ]
    
    var clues: [String] = [
        "The barrier at the entrance of a room",
        "A gap allowing access",
        "H2O",
        "A fruit composed of an indedible hard shell and a seed",
        "2 + 8",
        "equal in number, amount, or value",
    ]
    
    @State var selectedCell = [0, 0]
    @State private var showingAlert = false
    
    var body: some View {
        VStack {
            Spacer()
            VStack {
                ForEach(0..<7) { row in
                    HStack {
                        ForEach(0..<7) { col in
                            Cell(x: row, y: col, letter: self.inputs[row][col], selected: self.$selectedCell)
                        }
                    }
                }
            }
            Spacer()
            Text(getClue(clues: clues, selected: selectedCell))
                .padding(30)
            Spacer()
            VStack {
                ForEach(0..<3) {row in
                    HStack {
                        ForEach(0..<self.keyboard[row].count) { col in
                            Key(letter: self.keyboard[row][col], selectedCell: self.selectedCell, inputs: self.$inputs)
                        }
                    }
                }
            }
            Spacer()
            Button(action: {
                self.showingAlert = true
            }) {
                Text("Check")
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(words == inputs ? "Correct" : "Incorrect"), dismissButton: .default(Text("Close")))
            }
            Spacer()
        }
    }
    
    func getClue(clues: [String], selected: [Int]) -> String {
        switch selected {
        case [0,0], [2,0], [3,0], [4,0]:
            return "Across: \(clues[0])"
        case [1,0]:
            return "Across: \(clues[0])\nDown: \(clues[1])"
        case [1,3]:
            return "Across: \(clues[1])\nDown: \(clues[3])"
        case [1,1], [1,2], [1,3], [1,4], [1,5], [1,6], [1,7]:
            return "Down: \(clues[1])"
        case [2,3]:
            return "Across: \(clues[3])"
        case [3,3]:
            return "Across: \(clues[3])\nDown: \(clues[4])"
        case [3,4]:
            return "Across: \(clues[5])\nDown: \(clues[4])"
        case [3,5]:
            return "Down: \(clues[4])"
        case [5,4]:
            return "Across: \(clues[5])\nDown: \(clues[2])"
        case [5,1], [5,2], [5,3], [5,5]:
            return "Down: \(clues[2])"
        case [4,4], [6,4]:
            return "Across: \(clues[5])"
        default:
            return "Error"
        }
    }
}

struct Cell: View {
    var x: Int
    var y: Int
    var letter: String
    @Binding var selected: [Int]
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: 50, height: 50)
                .overlay(
                    Rectangle()
                        .stroke(Color.black, lineWidth: 4)
                )
                .foregroundColor(getColor(letter: letter, selected: selected, x: x, y: y))
                .padding(.top, -8)
                .padding(.leading, -8)
                .onTapGesture {
                    if self.letter != "." {
                        self.selected = [self.y, self.x]
                    }
                }
            Text("\(letter)")
                .padding(.top, -8)
                .padding(.leading, -8)
        }
    }
    
    func getColor(letter: String, selected: [Int], x: Int, y: Int) -> Color {
        if letter == "." {
            return Color.black
        }
        
        return selected == [y, x] ? Color.yellow : Color.white
    }
}

struct Key: View {
    var letter: String
    var selectedCell: [Int]
    @Binding var inputs: [[String]]
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: 32, height: 50)
                .overlay(
                    Rectangle()
                        .stroke(Color.black, lineWidth: 2)
                )
                .foregroundColor(Color.white)
                .onTapGesture {
                    let x = self.selectedCell[1]
                    let y = self.selectedCell[0]
                    self.inputs[x][y] = self.letter
                }
            Text("\(letter)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
