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
                        .padding()
                        .foregroundColor(Color.white)
                        .font(.system(size: 50, weight: .heavy))
                }
                VStack(spacing: 10){
                    HStack(spacing: 10){
                        doubleSizeButton(with: .ac)
                        calcButton(with: .clear, imageName: "delete.left", bgColor: .blue)
                        calcButton(with: .divide, bgColor: .gray)
                    }
                    HStack(spacing: 10){
                        calcButton(with: .seven)
                        calcButton(with: .eight)
                        calcButton(with: .nine)
                        calcButton(with: .multiply, imageName: "multiply", bgColor: .gray)
                    }
                    HStack(spacing: 10){
                        calcButton(with: .four)
                        calcButton(with: .five)
                        calcButton(with: .six)
                        calcButton(with: .subtract, bgColor: .gray)
                    }
                    HStack(spacing: 10){
                        calcButton(with: .one)
                        calcButton(with: .two)
                        calcButton(with: .three)
                        calcButton(with: .add, bgColor: .gray)
                    }
                    HStack(spacing: 10){
                        calcButton(with: .decimal, bgColor: .cyan)
                        calcButton(with: .zero)
                        calcButton(with: .power, bgColor: .green)
                        calcButton(with: .equal, bgColor: .purple)
                    }
                }
                
            }
        }
        .background(bgAnimation())
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
    
    func doubleSizeButton(with title: CalcButton, imageName: String? = nil, bgColor: Color = .red) -> some View {
        Button(action: {
            buttonPressed(cell: title.rawValue)
        }, label: {
            if let imgName = imageName {
                Image(systemName: imgName)
                    .font(.title)
                    .foregroundColor(Color.white)
            } else {
                Text(title.rawValue)
                    .font(.title)
                    .foregroundColor(Color.white)
            }
        })
        .frame(maxWidth: 150, maxHeight: 70)
        .background(bgColor)
        .cornerRadius(15)
    }
    
    func calcButton(with title: CalcButton, imageName: String? = nil, bgColor: Color = .orange) -> some View {
        Button(action: {
            buttonPressed(cell: title.rawValue)
        }, label: {
            if let imgName = imageName {
                Image(systemName: imgName)
                    .font(.title)
                    .foregroundColor(Color.white)
            } else {
                Text(title.rawValue)
                    .font(.title)
                    .foregroundColor(Color.white)
            }
        })
        .frame(maxWidth: 70, maxHeight: 70)
        .background(bgColor)
        .cornerRadius(15)
        
    }
    
    func bgAnimation() -> some View {
        LinearGradient(colors: [Color.blue, Color.cyan],
                       startPoint: .topLeading, endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(.all)
            .hueRotation(.degrees(animateBackground ? 45 : 0))
            .onAppear {
                withAnimation(.easeInOut(duration: 3)
                    .repeatForever(autoreverses: true)) {
                        animateBackground.toggle()
                    }
            }
    }

    
}




struct Calculator_Previews: PreviewProvider {
    static var previews: some View {
        Calculator()
    }
}
