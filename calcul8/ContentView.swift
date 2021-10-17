//
//  ContentView.swift
//  calcul8
//
//  Created by Alex Szabó on 2021. 10. 13..
//

import SwiftUI

extension Button {
    func asNumeric() -> some View {
        font(Font.system(.largeTitle, design: .monospaced))
                .foregroundColor(Color.primary)
    }

    func asOperation() -> some View {
        font(Font.system(.largeTitle, design: .monospaced))
                .foregroundColor(Color.white)
    }
}

let BUTTON_WIDTH: CGFloat = 80

struct ContentView: View {
    @ObservedObject var calculator = Calculator(calculationRepository: CalculationRepository())

    var body: some View {
        VStack {
            Rectangle()
                    .fill(Color(.systemGray6))
                    .frame(maxWidth: .infinity, maxHeight: 100, alignment: .top)
                    .clipped()
                    .overlay(Group {
                        Text(String(calculator.display))
                                .font(Font.system(.largeTitle, design: .monospaced))
                                .multilineTextAlignment(.trailing)
                                .clipped()
                                .padding(.horizontal, 100)
                                .foregroundColor(Color.primary)
                    }, alignment: .center)
            HStack {
                renderButton(Color(.quaternarySystemFill)).overlay(Button(Reset.operationSign) {
                    calculator.performOperation(operation: Reset())
                }.asNumeric())
                renderButton(Color(.quaternarySystemFill)).overlay(Button(Reverse.operationSign) {
                    calculator.performOperation(operation: Reverse())
                }.asNumeric())
                renderButton(Color(.quaternarySystemFill)).overlay(Button(Ratio.operationSign) {
                    calculator.performOperation(operation: Ratio())
                }.asNumeric())
                renderButton(Color(.orange)).overlay(Button(Multiplication.operationSign) {
                    calculator.performOperation(operation: Multiplication())
                }.asOperation())
            }.padding(.top, 50)
            HStack {
                renderButton().overlay(Button("7") {
                    calculator.append("7")
                }.asNumeric())
                renderButton().overlay(Button("8") {
                    calculator.append("8")
                }.asNumeric())
                renderButton().overlay(Button("9") {
                    calculator.append("9")
                }.asNumeric())
                renderButton(Color(.orange)).overlay(Button(Division.operationSign) {
                    calculator.performOperation(operation: Division())
                }.asOperation())
            }
            HStack {
                renderButton().overlay(Button("4") {
                    calculator.append("4")
                }.asNumeric())
                renderButton().overlay(Button("5") {
                    calculator.append("5")
                }.asNumeric())
                renderButton().overlay(Button("6") {
                    calculator.append("6")
                }.asNumeric())
                renderButton(Color(.orange)).overlay(Button(Addition.operationSign) {
                    calculator.performOperation(operation: Addition())
                }.asOperation())
            }
            HStack {
                renderButton().overlay(Button("1") {
                    calculator.append("1")
                }.asNumeric())
                renderButton().overlay(Button("2") {
                    calculator.append("2")
                }.asNumeric())
                renderButton().overlay(Button("3") {
                    calculator.append("3")
                }.asNumeric())
                renderButton(Color(.orange)).overlay(Button(Subtraction.operationSign) {
                    calculator.performOperation(operation: Subtraction())
                }.asOperation())
            }
            HStack {
                Spacer()
                        .frame(width: BUTTON_WIDTH, height: 1)
                        .clipped()
                renderButton().overlay(Button("0") {
                    calculator.append("0")
                }.asNumeric())
                renderButton().overlay(Button(".") {
                    calculator.append(".")
                }.asNumeric())
                renderButton(Color(.orange)).overlay(Button(RevealResult.operationSign) {
                    calculator.performOperation(operation: RevealResult())
                }.asOperation())
            }
        }
    }

    private func renderButton(_ color: Color = Color(.secondarySystemFill)) -> some View {
        Circle()
                .fill(color)
                .frame(width: BUTTON_WIDTH, height: BUTTON_WIDTH)
                .clipped()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
