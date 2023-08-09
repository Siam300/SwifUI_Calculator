//
//  Calculator.swift
//  Calculator
//
//  Created by Auto on 7/27/23.
//

import SwiftUI
struct Calculator: View {
    let operators = ["÷", "+", "X"]
    
    @State var visibleWorkings = ""
    @State var visibleResults: Float = 0.0
    @State var showAlert: Bool = false
    
    var body: some View {
        ZStack {
            Color.cyan
                .edgesIgnoringSafeArea(.all)
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
                
                buttonView(buttonPressed: buttonPressed)
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
    
    struct buttonView: View {
        var buttonPressed: (String) -> Void
        
        var body: some View {
            VStack(spacing: 10) {
                
                HStack(spacing: 10){
                    Button(action: {
                        buttonPressed("AC")
                    }, label: {
                        Text("AC")
                            .font(.title)
                            .frame(maxWidth: 140, maxHeight: 70)
                            .background(Color.red)
                            .foregroundColor(Color.white)
                            .cornerRadius(15)
                    })
                    
                    Button(action: {
                        buttonPressed("Clear")
                    }, label: {
                        Image(systemName: "delete.left")
                            .font(.title)
                            .frame(maxWidth: 70, maxHeight: 70)
                            .background(Color.orange)
                            .foregroundColor(Color.white)
                            .cornerRadius(15)
                    })
                    
                    //                Button(action: {
                    //                    buttonPressed("%")
                    //                }, label: {
                    //                    Text("%")
                    //                        .font(.title)
                    //                        .frame(maxWidth: 70, maxHeight: 70)
                    //                        .background(Color.orange)
                    //                        .foregroundColor(Color.white)
                    //                        .cornerRadius(15)
                    //                })
                    
                    Button(action: {
                        buttonPressed("÷")
                    }, label: {
                        Text("÷")
                            .font(.title)
                            .frame(maxWidth: 70, maxHeight: 70)
                            .background(Color.orange)
                            .foregroundColor(Color.white)
                            .cornerRadius(15)
                    })
                }
                
                HStack(spacing: 10){
                    Button(action: {
                        buttonPressed("7")
                    }, label: {
                        Text("7")
                            .font(.title)
                            .frame(maxWidth: 70, maxHeight: 70)
                            .background(Color.orange)
                            .foregroundColor(Color.white)
                            .cornerRadius(15)
                    })
                    
                    Button(action: {
                        buttonPressed("8")
                    }, label: {
                        Text("8")
                            .font(.title)
                            .frame(maxWidth: 70, maxHeight: 70)
                            .background(Color.orange)
                            .foregroundColor(Color.white)
                            .cornerRadius(15)
                    })
                    
                    Button(action: {
                        buttonPressed("9")
                    }, label: {
                        Text("9")
                            .font(.title)
                            .frame(maxWidth: 70, maxHeight: 70)
                            .background(Color.orange)
                            .foregroundColor(Color.white)
                            .cornerRadius(15)
                    })
                    
                    Button(action: {
                        buttonPressed("X")
                    }, label: {
                        Image(systemName: "multiply")
                            .font(.title)
                            .frame(maxWidth: 70, maxHeight: 70)
                            .background(Color.orange)
                            .foregroundColor(Color.white)
                            .cornerRadius(15)
                    })
                }
                
                HStack(spacing: 10){
                    Button(action: {
                        buttonPressed("4")
                    }, label: {
                        Text("4")
                            .font(.title)
                            .frame(maxWidth: 70, maxHeight: 70)
                            .background(Color.orange)
                            .foregroundColor(Color.white)
                            .cornerRadius(15)
                    })
                    
                    Button(action: {
                        buttonPressed("5")
                    }, label: {
                        Text("5")
                            .font(.title)
                            .frame(maxWidth: 70, maxHeight: 70)
                            .background(Color.orange)
                            .foregroundColor(Color.white)
                            .cornerRadius(15)
                    })
                    
                    Button(action: {
                        buttonPressed("6")
                    }, label: {
                        Text("6")
                            .font(.title)
                            .frame(maxWidth: 70, maxHeight: 70)
                            .background(Color.orange)
                            .foregroundColor(Color.white)
                            .cornerRadius(15)
                    })
                    
                    Button(action: {
                        buttonPressed("-")
                    }, label: {
                        Image(systemName: "minus")
                            .font(.title)
                            .frame(maxWidth: 70, maxHeight: 70)
                            .background(Color.orange)
                            .foregroundColor(Color.white)
                            .cornerRadius(15)
                    })
                }
                
                HStack(spacing: 10){
                    Button(action: {
                        buttonPressed("1")
                    }, label: {
                        Text("1")
                            .font(.title)
                            .frame(maxWidth: 70, maxHeight: 70)
                            .background(Color.orange)
                            .foregroundColor(Color.white)
                            .cornerRadius(15)
                    })
                    
                    Button(action: {
                        buttonPressed("2")
                    }, label: {
                        Text("2")
                            .font(.title)
                            .frame(maxWidth: 70, maxHeight: 70)
                            .background(Color.orange)
                            .foregroundColor(Color.white)
                            .cornerRadius(15)
                    })
                    
                    Button(action: {
                        buttonPressed("3")
                    }, label: {
                        Text("3")
                            .font(.title)
                            .frame(maxWidth: 70, maxHeight: 70)
                            .background(Color.orange)
                            .foregroundColor(Color.white)
                            .cornerRadius(15)
                    })
                    
                    Button(action: {
                        buttonPressed("+")
                    }, label: {
                        Image(systemName: "plus")
                            .font(.title)
                            .frame(maxWidth: 70, maxHeight: 70)
                            .background(Color.orange)
                            .foregroundColor(Color.white)
                            .cornerRadius(15)
                    })
                }
                
                HStack(spacing: 10){
                    Button(action: {
                        buttonPressed(".")
                    }, label: {
                        Text(".")
                            .font(.title)
                            .frame(maxWidth: 70, maxHeight: 70)
                            .background(Color.orange)
                            .foregroundColor(Color.white)
                            .cornerRadius(15)
                    })
                    
                    Button(action: {
                        buttonPressed("0")
                    }, label: {
                        Text("0")
                            .font(.title)
                            .frame(maxWidth: 70, maxHeight: 70)
                            .background(Color.orange)
                            .foregroundColor(Color.white)
                            .cornerRadius(15)
                    })
                    
                    Button(action: {
                        buttonPressed("^")
                    }, label: {
                        Text("^")
                            .font(.title)
                            .frame(maxWidth: 70, maxHeight: 70)
                            .background(Color.orange)
                            .foregroundColor(Color.white)
                            .cornerRadius(15)
                    })
                    
                    Button(action: {
                        buttonPressed("=")
                        
                    }, label: {
                        Image(systemName: "equal")
                            .font(.title)
                            .frame(maxWidth: 70, maxHeight: 70)
                            .background(Color.orange)
                            .foregroundColor(Color.white)
                            .cornerRadius(15)
                    })
                }
            }
        }
    }
}
    
    struct Calculator_Previews: PreviewProvider {
        static var previews: some View {
            Calculator()
        }
    }
