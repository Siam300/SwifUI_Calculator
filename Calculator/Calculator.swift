//
//  Calculator.swift
//  Calculator
//
//  Created by Auto on 7/27/23.
//

import SwiftUI
struct Calculator: View {
    let operators = ["÷", "+", "X"]
    
    @State var animateBackground: Bool = false
    @State var visibleWorkings = ""
    @State var visibleResults: Float = 0.0
    @State var showAlert: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text(visibleWorkings)
                        .font(.system(size: 90))
                    
                }
                
                .padding()
                .padding(.horizontal)
                
                HStack{
                    Spacer()
                    Text(String(format: "%.3f", visibleResults))
                    //Text(formatResult(val: visibleResults))
                        .padding()
                        .foregroundColor(Color.white)
                        .font(.system(size: 50, weight: .heavy))
                }
                VStack(spacing: 10){
                    HStack(spacing: 10){
                        calcButton(with: "AC")
                            .frame(width: 150, height: 70)
                            .background(Color.red)
                            .cornerRadius(15)
                        calcButton(with: "Clear", imageName: "delete.left")
                            .frame(width: 70, height: 70)
                            .background(Color.blue)
                            .cornerRadius(15)
                        calcButton(with: "÷")
                            .frame(width: 70, height: 70)
                            .background(Color.gray)
                            .cornerRadius(15)
                    }
                    HStack(spacing: 10){
                        calcButton(with: "7")
                            .frame(width: 70, height: 70)
                            .background(Color.orange)
                            .cornerRadius(15)
                        calcButton(with: "8")
                            .frame(width: 70, height: 70)
                            .background(Color.orange)
                            .cornerRadius(15)
                        calcButton(with: "9")
                            .frame(width: 70, height: 70)
                            .background(Color.orange)
                            .cornerRadius(15)
                        calcButton(with: "X", imageName: "multiply")
                            .frame(width: 70, height: 70)
                            .background(Color.gray)
                            .cornerRadius(15)
                    }
                    HStack(spacing: 10){
                        calcButton(with: "4")
                            .frame(width: 70, height: 70)
                            .background(Color.orange)
                            .cornerRadius(15)
                        calcButton(with: "5")
                            .frame(width: 70, height: 70)
                            .background(Color.orange)
                            .cornerRadius(15)
                        calcButton(with: "6")
                            .frame(width: 70, height: 70)
                            .background(Color.orange)
                            .cornerRadius(15)
                        calcButton(with: "-")
                            .frame(width: 70, height: 70)
                            .background(Color.gray)
                            .cornerRadius(15)
                    }
                    HStack(spacing: 10){
                        calcButton(with: "1")
                            .frame(width: 70, height: 70)
                            .background(Color.orange)
                            .cornerRadius(15)
                        calcButton(with: "2")
                            .frame(width: 70, height: 70)
                            .background(Color.orange)
                            .cornerRadius(15)
                        calcButton(with: "3")
                            .frame(width: 70, height: 70)
                            .background(Color.orange)
                            .cornerRadius(15)
                        calcButton(with: "+")
                            .frame(width: 70, height: 70)
                            .background(Color.gray)
                            .cornerRadius(15)
                    }
                    HStack(spacing: 10){
                        calcButton(with: ".")
                            .frame(width: 70, height: 70)
                            .background(Color.cyan)
                            .cornerRadius(15)
                        calcButton(with: "0")
                            .frame(width: 70, height: 70)
                            .background(Color.orange)
                            .cornerRadius(15)
                        calcButton(with: "^")
                            .frame(width: 70, height: 70)
                            .background(Color.green)
                            .cornerRadius(15)
                        calcButton(with: "=")
                            .frame(width: 70, height: 70)
                            .background(Color.purple)
                            .cornerRadius(15)
                    }
                }
                
            }
        }
        .background{
            LinearGradient(colors: [Color.blue, Color.cyan],
                           startPoint: .topLeading , endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(.all)
            .hueRotation(.degrees(animateBackground ? 45 : 0))
            .onAppear {
                withAnimation(.easeInOut(duration:3)
                    .repeatForever(autoreverses: true)) {
                        animateBackground.toggle()
                    }
            }
        }
    }
    
    enum CalcButton: String, Hashable {
        case ac = "AC"
        case clear = "Clear"
        case divide = "÷"
        case seven = "7"
        case eight = "8"
        case nine = "9"
        case multiply = "X"
        case four = "4"
        case five = "5"
        case six = "6"
        case subtract = "-"
        case one = "1"
        case two = "2"
        case three = "3"
        case add = "+"
        case decimal = "."
        case zero = "0"
        case power = "^"
        case equal = "="
    }
    
    let buttons: [[CalcButton]] = [
        [.ac, .clear, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .subtract],
        [.one, .two, .three, .add],
        [.decimal, .zero, .power, .equal],
    ]
    
    func buttonPressed(cell: String) {
        if let button = CalcButton(rawValue: cell) {
            switch button {
            case .ac:
                visibleWorkings = ""
                visibleResults = 0.0
            case .clear:
                visibleWorkings = String(visibleWorkings.dropLast())
                visibleResults = 0.0
            case .divide, .multiply, .subtract, .add:
                if !visibleWorkings.isEmpty {
                    let last = String(visibleWorkings.last!)
                    if operators.contains(last) {
                        visibleWorkings.removeLast()
                    }
                    visibleWorkings += button.rawValue
                }
            case .seven, .eight, .nine, .four, .five, .six, .one, .two, .three, .zero, .decimal, .power:
                visibleWorkings += button.rawValue
            case .equal:
                buttonPressedEqual()
            }
        }
    }
    
    func addOperator(_ cell : String){
        if !visibleWorkings.isEmpty{
            let last = String(visibleWorkings.last!)
            if operators.contains(last){
                visibleWorkings.removeLast()
            }
            visibleWorkings += cell
        }
    }
    
    func addMinus(){
        if visibleWorkings.isEmpty || visibleWorkings.last! != "-"{
            visibleWorkings += "-"
        }
    }
    
    func addDecimal() {
        if !visibleWorkings.contains(".") {
            visibleWorkings += "."
        }
    }
    
    func addPower() {
        if let lastCharacter = visibleWorkings.last {
            if lastCharacter.isNumber {
                visibleWorkings += "^"
            }
        }
    }
    
    func calculateResults() -> Float? {
        var workings = visibleWorkings.replacingOccurrences(of: "X", with: "*")
        workings = workings.replacingOccurrences(of: "^", with: "**")
        
        // Perform floating-point division
        workings = workings.replacingOccurrences(of: "÷", with: "/")
        
        let expression = NSExpression(format: workings)
        guard let result = expression.expressionValue(with: nil, context: nil) as? Float else {
            return nil
        }
        
        if result.isInfinite || result.isNaN {
            return nil
        }
        
        return result
    }
    
    
    func validInput() -> Bool{
        if(visibleWorkings.isEmpty){
            return false
        }
        let last = String(visibleWorkings.last!)
        
        if(operators.contains(last) || last == "-"){
            if(last != "%" || visibleWorkings.count == 1)
            {
                return false
            }
        }
        
        return true
    }
    
    func formatResult(val: Double) -> String {
        return String(format: "%.3f", val)
    }
    
    func buttonPressedEqual() {
        if let result = calculateResults() {
            visibleResults = result
        } else {
            visibleResults = 0.0
            showAlert = true
        }
    }
    
    func calcButton(with title: String) -> some View {
        Button(action: {
            buttonPressed(cell: title)
        }, label: {
            Text(title)
                .font(.title)
                .frame(maxWidth: 70, maxHeight: 70)
                //.background(Color.orange)
                .foregroundColor(Color.white)
                .cornerRadius(15)
        })
    }
    
    func calcButton(with title: String, imageName: String) -> some View {
        Button(action: {
            buttonPressed(cell: title)
        }, label: {
            Image(systemName: imageName)
                .font(.title)
                .frame(maxWidth: 70, maxHeight: 70)
                //.background(Color.orange)
                .foregroundColor(Color.white)
                //.cornerRadius(15)
        })
    }
    
}
    
    struct Calculator_Previews: PreviewProvider {
        static var previews: some View {
            Calculator()
        }
    }
