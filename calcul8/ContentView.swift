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
            renderResultContainer()
            HStack {
                let alternativeOperationButtonColor = Color(.orange).opacity(0.8)
                renderOperationButton(Reset.self, color: alternativeOperationButtonColor)
                renderOperationButton(Reverse.self, color: alternativeOperationButtonColor)
                renderOperationButton(Ratio.self, color: alternativeOperationButtonColor)
                renderOperationButton(Multiplication.self)
            }.padding(.top, 50)
            HStack {
                renderDigitButton("7")
                renderDigitButton("8")
                renderDigitButton("9")
                renderOperationButton(Division.self)
            }
            HStack {
                renderDigitButton("4")
                renderDigitButton("5")
                renderDigitButton("6")
                renderOperationButton(Addition.self)
            }
            HStack {
                renderDigitButton("1")
                renderDigitButton("2")
                renderDigitButton("3")
                renderOperationButton(Subtraction.self)
            }
            HStack {
                Spacer()
                        .frame(width: BUTTON_WIDTH, height: 1)
                        .clipped()
                renderDigitButton("0")
                renderDigitButton(".")
                renderOperationButton(RevealResult.self)
            }
        }
    }

    private func renderResultContainer() -> some View {
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
    }

    private func renderOperationButton(
            _ operationClass: SimpleMathematicalOperation.Type,
            color: Color = Color(.orange)
    ) -> some View {
        renderButton(color).overlay(Button(operationClass.operationSign) {
            calculator.performOperation(operation: operationClass.init())
        }.asOperation())
    }

    private func renderDigitButton(_ label: String) -> some View {
        renderButton().overlay(Button(label) {
            calculator.append(label)
        }.asNumeric())
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
