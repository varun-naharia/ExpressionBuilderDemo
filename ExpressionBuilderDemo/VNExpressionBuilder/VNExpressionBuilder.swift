//
//  ExpressionBuilder.swift
//  ExpressionBuilderDemo
//
//  Created by Varun Naharia on 12/12/17.
//  Copyright © 2017 Varun Naharia. All rights reserved.
//

import UIKit

protocol VNExpressionBuilderDelegate {
    func expressionValueChanged(value:String)
}

class VNExpressionBuilder: UIView {
    var view: UIView!
    @IBOutlet weak var expressionField: CustomTextView!
    
    var functionArray:[[String:Any]] = []
    var argumentArray:[[String:Any]] = []
    var operatorArray:[String] = []
    var isFunctionComplete:Bool = true
    var currentFunctionMaxArg:Int!
    var currentFunctionMinArg:Int!
    var currentArgument:String = ""
    var numberOfArgInCurrentFunction:Int = 0
    var expressionStack:[[String:Any]] = []
    var expressionValid = false
    var delegate:VNExpressionBuilderDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpView()
        xibSetup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.setUpView()
    }
    
    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.view.isOpaque = false
        view.isOpaque = false
        updateView()
    }
    
    func updateView() {
        expressionField.delegate = self
    }
    
    func setUpView() {
        
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        // use bounds not frame or it'll be offset
        view.frame = bounds
        view.backgroundColor = self.backgroundColor
        // Make the view stretch with containing view
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
        self.updateView()
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "VNExpressionBuilder", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    func addFunction(functionName:String, minArg:Int, maxArg:Int) {
        if(getStackLastObjectType() == "operator" || isReadyToAddNewFunction())// Check before adding new function that is there any function and it is complete and there are oprands after previous function.
        {
            appendFunction(functionName: functionName, minArg: minArg, maxArg: maxArg)
        }
        else
        {
            let alert = UIAlertController(title: "Alert", message: "Please complete existing expression before adding new function.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: nil))
            self.parentViewController().present(alert, animated: true, completion: nil)
        }
    }
    private func getStackLastObjectType() -> String {
        if(expressionStack.count > 0)
        {
            let dict = expressionStack.last!
            return dict["Type"] as! String
        }
        else
        {
            return "nil"
        }
    }
    
    private func appendFunction(functionName:String, minArg:Int, maxArg:Int)  {
        let functionDict:[String:Any] = ["Type":"function", "FunctionName":functionName, "MinArg":minArg, "MaxArg":maxArg, "ArgList":[], "Value":"\(functionName)()"]
        expressionStack.append(functionDict)
        setExperessionValidation()
        expressionField.text = "\(expressionField.text!) \(functionName)()"
        let startPosition: UITextPosition = expressionField.beginningOfDocument
        if let selectedRange = expressionField.selectedTextRange {
            
            _ = expressionField.offset(from: startPosition, to: selectedRange.start)
            
//            print("\(cursorPosition)")
        }
        
        let arbitraryValue: Int = expressionField.text.count-1
        // Change cursor position back to inside function to take argument. And keep cursor there until argument for function are over.
        if let newPosition = expressionField.position(from: expressionField.beginningOfDocument, offset: arbitraryValue) {
            expressionField.selectedTextRange = expressionField.textRange(from: newPosition, to: newPosition)
        }
        
        currentFunctionMaxArg = maxArg
        currentFunctionMinArg = minArg
        numberOfArgInCurrentFunction = 0 // New funtion is added so there is no argument.
        isFunctionComplete = false //There is no argument so function is incomplete.
    }
    
    private func isReadyToAddNewFunction() -> Bool {
        if(getStackLastObjectType() == "nil" || getStackLastObjectType() == "operator")
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    private func isOperator(text:String) -> Bool {
        switch text {
        case "+":
            return true
        case "-":
            return true
        case "*":
            return true
        case "/":
            return true
        case "?":
            return true
        case ":":
            return true
        case "!":
            return true
        case "&":
            return true
        case "|":
            return true
        case "(":
            return true
        case ")":
            return true
        default:
            return false
        }
    }
    
    private func getOperatorName(text:String) -> String {
        switch text {
        case "+":
            return "addition"
        case "-":
            return "subtraction"
        case "*":
            return "multiply"
        case "/":
            return "division"
            //        case "?":
            //            return "question"
            //        case ":":
            //            return "colon"
            //        case "!":
            //            return "expination"
            //        case "&":
            //            return "and"
            //        case "|":
            //            return "or"
            //        case "(":
            //            return "left_round_bracket"
            //        case ")":
        //            return "right_round_bracket"
        default:
            return ""
        }
    }
    
    private func addOperator(text:String){
        let functionDict:[String:Any] = ["Type":"operator", "Name": getOperatorName(text: text), "Value":text]
        expressionStack.append(functionDict)
        setExperessionValidation()
    }
    
    private func appendOperator(text:String){
        if(validOperatorToAppend(text:text))
        {
            let functionDict:[String:Any] = ["Type":"operator", "Name": getOperatorName(text: text), "Value":text]
            expressionStack.append(functionDict)
            setExperessionValidation()
        }
        else
        {
            let alert = UIAlertController(title: "Alert", message: "Only one operator can be added.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: nil))
            self.parentViewController().present(alert, animated: true, completion: nil)
        }
    }
    
    private func isOprand(text:String) -> Bool {
        switch text {
        case "0":
            return true
        case "1":
            return true
        case "2":
            return true
        case "3":
            return true
        case "4":
            return true
        case "5":
            return true
        case "6":
            return true
        case "7":
            return true
        case "8":
            return true
        case "9":
            return true
        case ".":
            return true
        default:
            return false
        }
    }
    
    private func addOprand(text:String){
        let functionDict:[String:Any] = ["Type":"oprand", "Value":text]
        expressionStack.append(functionDict)
        setExperessionValidation()
    }
    
    private func appendOprand(text:String){
        let dict = expressionStack.last
        let functionDict:[String:Any] = ["Type":"oprand", "Value":"\(dict!["Value"] as! String)\(text)"]
        expressionStack.remove(at: expressionStack.count-1)
        expressionStack.append(functionDict)
        setExperessionValidation()
    }
    
    private func removeCharachterFromOprand(){
        let dict = expressionStack.last
        let oldOprand = dict!["Value"] as! String
        let newOprand = String(oldOprand.dropLast())
        let functionDict:[String:Any] = ["Type":"oprand", "Value":"\(newOprand)"]
        expressionStack.remove(at: expressionStack.count-1)
        expressionStack.append(functionDict)
        setExperessionValidation()
    }
    
    private func validOperatorToAppend(text:String) -> Bool {
        
        let dict = expressionStack.last!
        let lastOperator = dict["Name"] as! String
        if(lastOperator == "!" && text == "=")
        {
            
        }
        return false
    }
    
    private func setExperessionValidation() {
        if(expressionStack.count > 0)
        {
            if(expressionStack.last!["Type"] as! String != "operator")
            {
                expressionValid = true
            }
            else
            {
                expressionValid = false
            }
        }
        else
        {
            expressionValid = true
        }
        if(expressionValid)
        {
            self.layer.borderWidth = 0
            self.layer.borderColor = UIColor.clear.cgColor
        }
        else
        {
            self.layer.borderWidth = 2
            self.layer.borderColor = UIColor.red.cgColor
        }
    }
    
    func getExpressionValue() -> String {
        var expressionStackToModify = expressionStack
        if(expressionStackToModify.last != nil && expressionStackToModify.last!["Type"] as! String != "operator")
        {
            while expressionStackToModify.count > 0 {
                let  secondOprand = expressionStackToModify.popLast()
                let operatortype = expressionStackToModify.popLast()
                let firstOprand = expressionStackToModify.popLast()
                
                if(secondOprand!["Type"] as! String == "function")
                {
                    let valueEval = solveFunction(function: secondOprand!)
                    if(firstOprand != nil )
                    {
                        expressionStackToModify.append(firstOprand!)
                    }
                    if(operatortype != nil)
                    {
                        expressionStackToModify.append(operatortype!)
                    }
                    expressionStackToModify.append(["Type":"oprand", "Value":"\(valueEval)"])
                }
                else
                {
                    if(firstOprand != nil && operatortype != nil && secondOprand != nil)
                    {
                        let valueEval = solveExpression(firstOprand:firstOprand!["Value"] as! String, secondOprand:secondOprand!["Value"] as! String, operatorType:operatortype!["Value"] as! String)
                        expressionStackToModify.append(["Type":"oprand", "Value":"\(valueEval)"])
                    }
                    else
                    {
                        if(firstOprand != nil)
                        {
                            expressionStackToModify.append(firstOprand!)
                        }
                        if(operatortype != nil)
                        {
                            expressionStackToModify.append(operatortype!)
                        }
                        if(secondOprand != nil)
                        {
                            expressionStackToModify.append(secondOprand!)
                        }
                        break
                    }
                }
            }
            callDelegate(value: expressionStackToModify.last!["Value"] as! String)
            return expressionStackToModify.last!["Value"] as! String
        }
        else
        {
            callDelegate(value: "ERROR")
            return "ERROR"
        }
    }
    
    private func callDelegate(value:String) {
        if(self.delegate != nil)
        {
            self.delegate?.expressionValueChanged(value: value)
        }
    }
    
    private func solveExpression(firstOprand:String, secondOprand:String, operatorType:String) -> String {
        switch operatorType {
        case "+":
            return "\(Double(firstOprand)! + Double(secondOprand)!)"
        case "-":
            return "\(Double(firstOprand)! - Double(secondOprand)!)"
        case "*":
            return "\(Double(firstOprand)! * Double(secondOprand)!)"
        case "/":
            return "\(Double(firstOprand)! / Double(secondOprand)!)"
        default:
            assertionFailure("Operator Type is not in the list")
        }
        return ""
    }
    
    private func solveFunction(function:[String:Any]) -> String {
        switch function["FunctionName"] as! String {
        case "MIN":
            return "\(MathFunctions.MIN(args: (function["ArgList"] as! [String]).flatMap{ Double($0) }))"
        case "MAX":
            return "\(MathFunctions.MAX(args: (function["ArgList"] as! [String]).flatMap{ Double($0) }))"
        case "ABS":
            return "\(MathFunctions.ABS(arg: Double((function["ArgList"] as! [String]).last!)!))"
        case "ROUND":
            return "\(MathFunctions.ROUND(arg: Double((function["ArgList"] as! [String]).first!)!, precision: Int((function["ArgList"] as! [String]).last!)!))"
        case "FLOOR":
            return "\(MathFunctions.FLOOR(arg: Double((function["ArgList"] as! [String]).first!)!))"
        case "CEILING":
            return "\(MathFunctions.CEILING(arg: Double((function["ArgList"] as! [String]).first!)!))"
        case "LOG":
            return "\(MathFunctions.LOG(arg: Double((function["ArgList"] as! [String]).first!)!))"
        case "LOG10":
            return "\(MathFunctions.LOG10(arg: Double((function["ArgList"] as! [String]).first!)!))"
        case "SQRT":
            return "\(MathFunctions.SQRT(arg: Double((function["ArgList"] as! [String]).first!)!))"
        case "SIN":
            return "\(MathFunctions.SIN(arg: Double((function["ArgList"] as! [String]).first!)!))"
        case "COS":
            return "\(MathFunctions.COS(arg: Double((function["ArgList"] as! [String]).first!)!))"
        case "TAN":
            return "\(MathFunctions.TAN(arg: Double((function["ArgList"] as! [String]).first!)!))"
        case "CSC":
            return "\(MathFunctions.CSC(arg: Double((function["ArgList"] as! [String]).first!)!))"
        case "SEC":
            return "\(MathFunctions.SEC(arg: Double((function["ArgList"] as! [String]).first!)!))"
        case "COT":
            return "\(MathFunctions.COT(arg: Double((function["ArgList"] as! [String]).first!)!))"
        case "ASIN":
            return "\(MathFunctions.ASIN(arg: Double((function["ArgList"] as! [String]).first!)!))"
        case "ACOS":
            return "\(MathFunctions.ACOS(arg: Double((function["ArgList"] as! [String]).first!)!))"
        case "ATAN":
            return "\(MathFunctions.ATAN(arg: Double((function["ArgList"] as! [String]).first!)!))"
        case "ACOT":
            return "\(MathFunctions.ACOT(arg: Double((function["ArgList"] as! [String]).first!)!))"
        case "ATAN2":
            return "\(MathFunctions.ATAN2(arg: Double((function["ArgList"] as! [String]).first!)!))"
        case "SINH":
            return "\(MathFunctions.SINH(arg: Double((function["ArgList"] as! [String]).first!)!))"
        case "COSH":
            return "\(MathFunctions.COSH(arg: Double((function["ArgList"] as! [String]).first!)!))"
        case "TANH":
            return "\(MathFunctions.TANH(arg: Double((function["ArgList"] as! [String]).first!)!))"
        case "COTH":
            return "\(MathFunctions.COTH(arg: Double((function["ArgList"] as! [String]).first!)!))"
        case "SECH":
            return "\(MathFunctions.SECH(arg: Double((function["ArgList"] as! [String]).first!)!))"
        case "CSCH":
            return "\(MathFunctions.CSCH(arg: Double((function["ArgList"] as! [String]).first!)!))"
        case "ASINH":
            return "\(MathFunctions.ASINH(arg: Double((function["ArgList"] as! [String]).first!)!))"
        case "ACOSH":
            return "\(MathFunctions.ACOSH(arg: Double((function["ArgList"] as! [String]).first!)!))"
        case "ATANH":
            return "\(MathFunctions.ATANH(arg: Double((function["ArgList"] as! [String]).first!)!))"
        case "RAD":
            return "\(MathFunctions.RAD(arg: Double((function["ArgList"] as! [String]).first!)!))"
        case "DEG":
            return "\(MathFunctions.DEG(arg: Double((function["ArgList"] as! [String]).first!)!))"
        default:
            assertionFailure("Invalid function \(function["FunctionName"] as! String)")
        }
        return ""
    }
    
    private func addArgumentToFunction(text:String)  {
        //        let functionDict:[String:Any] = ["Type":"function", "FunctionName":functionName, "MinArg":minArg, "MaxArg":maxArg, "ArgList":[], "Value":"\(functionName)()"]
        //        expressionStack.append(functionDict)
        var oldFunctionDict:[String:Any] = expressionStack.last!
        if(text != ",")
        {
            
            var oldArgumentList:[Any] = oldFunctionDict["ArgList"] as! [Any]
            if(oldArgumentList.count > 0)
            {
                var lastArgument:String = (oldArgumentList.last! as! String)
                
                lastArgument = "\(lastArgument)\(text)"
                oldArgumentList.remove(at: oldArgumentList.count-1)
                oldArgumentList.append(lastArgument)
            }
            else
            {
                oldArgumentList.append(text)
                
            }
            oldFunctionDict["ArgList"] = oldArgumentList
        }
        else
        {
            oldFunctionDict = expressionStack.last!
            var oldArgumentList:[Any] = oldFunctionDict["ArgList"] as! [Any]
            let functionName = oldFunctionDict["FunctionName"] as! String
            oldArgumentList.append("")
            oldFunctionDict["ArgList"] = oldArgumentList
            oldFunctionDict["Value"] = "\(functionName)(\((oldArgumentList as! [String]).joined(separator: ","))"
        }
        expressionStack.remove(at: expressionStack.count-1)
        expressionStack.append(oldFunctionDict)
    }
    
    func shouldBacksapceReturn(textView:UITextView, text:String) -> Bool {
        // MARK: - Delete function, expression, value (recreate expression through functionArray, argumentArray and oprandsArray)
        if(getStackLastObjectType() == "nil")
        {
            print(expressionStack)
            _ = getExpressionValue()
            setExperessionValidation()
            return true
        }
        else if(getStackLastObjectType() == "operator")
        {
            expressionStack.remove(at: expressionStack.count-1)
            print(expressionStack)
            _ = getExpressionValue()
            setExperessionValidation()
            return true
        }
        else if(getStackLastObjectType() == "oprand")
        {
            if(expressionStack.last!["Value"] as! String == "")
            {
                expressionStack.remove(at: expressionStack.count-1)
            }
            else
            {
                removeCharachterFromOprand()
                if(expressionStack.last!["Value"] as! String == "")
                {
                    expressionStack.remove(at: expressionStack.count-1)
                }
            }
            print(expressionStack)
            _ = getExpressionValue()
            setExperessionValidation()
            return true
        }
        else if(getStackLastObjectType() == "function")
        {
            if(numberOfArgInCurrentFunction == 0)
            {
                expressionStack.remove(at: expressionStack.count-1)
                textView.text = ""
                for dict in expressionStack
                {
                    textView.text = "\(textView.text!)\(dict["Value"] as! String)"
                }
               
            }
            else
            {
                if(currentArgument != "")
                {
                    currentArgument = String(currentArgument.dropLast())
                    if(currentArgument == "")
                    {
                        numberOfArgInCurrentFunction -= 1
                        var lastExp = expressionStack.last!
                        lastExp["ArgList"] = (lastExp["ArgList"] as! [String]).dropLast()
                        expressionStack.remove(at: expressionStack.count - 1)
                        expressionStack.append(lastExp)
                        if(lastExp.count > 0)
                        {
                            let argList:[String:Any] = expressionStack.last!
                            currentArgument = (argList["ArgList"] as! [String]).last!
                        }
                    }
                    else
                    {
                        var lastExp = expressionStack.last!
                        var lastArgList = lastExp["ArgList"] as! [String]
                        let lastArg = String(lastArgList.last!.dropLast())
                        lastArgList.remove(at: lastArgList.count-1)
                        lastArgList.append(lastArg)
                        lastExp["ArgList"] = lastArgList
                        expressionStack.remove(at: expressionStack.count - 1)
                        expressionStack.append(lastExp)
                    }
                }
                print(currentArgument)
                print(expressionStack)
                _ = getExpressionValue()
                return true
            }
            setExperessionValidation()
            print(expressionStack)
            _ = getExpressionValue()
            return false
        }
        print(expressionStack)
        _ = getExpressionValue()
        setExperessionValidation()
        return false
    }

}

extension VNExpressionBuilder:UITextViewDelegate
{
    func textViewDidBeginEditing(_ textView: UITextView) {
        // Set cursor postion to at end or inside function if function argument is not over.
        var arbitraryValue: Int = expressionField.text.count
        if(!isFunctionComplete)
        {
            arbitraryValue = expressionField.text.count-1
        }
        let startPosition: UITextPosition = expressionField.beginningOfDocument
        if let selectedRange = expressionField.selectedTextRange {
            _ = expressionField.offset(from: startPosition, to: selectedRange.start)
//            print("\(cursorPosition)")
        }
        
        if let newPosition = expressionField.position(from: expressionField.beginningOfDocument, offset: arbitraryValue) {
            expressionField.selectedTextRange = expressionField.textRange(from: newPosition, to: newPosition)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let  char = text.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        if (isBackSpace == -92) {
            return shouldBacksapceReturn(textView:textView, text:text)
        }
        
        if(isOperator(text:text))
        {
            if(getStackLastObjectType() == "operator")
            {
                appendOperator(text:text)
            }
            else
            {
                addOperator(text:text)
            }
            print(expressionStack)
            _ = getExpressionValue()
            return true
        }
        else if(getStackLastObjectType() == "function")
        {
            if(text == ",")
            {
                if(currentFunctionMaxArg > 1 && numberOfArgInCurrentFunction == 0) // Check and increment numberOfArgInCurrentFunction for function with argument 2 or more
                {
                    numberOfArgInCurrentFunction += 1
                    currentArgument = ""
                }
                else if(currentFunctionMaxArg == 0) // Check and increment numberOfArgInCurrentFunction for function with n number of argument.
                {
                    numberOfArgInCurrentFunction += 1
                    currentArgument = ""
                }
                else
                {
                    let alert = UIAlertController(title: "Alert", message: "Number of argument for the function is over", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: nil))
                    self.parentViewController().present(alert, animated: true, completion: nil)
                    return false
                }
                addArgumentToFunction(text: text)
                print(expressionStack)
                _ = getExpressionValue()
                return true
            }
            //If we are here then we have to take argument for current function by appending charachters each time
            if(currentFunctionMaxArg != nil)
            {
                
                currentArgument = "\(currentArgument)\(text)"
                numberOfArgInCurrentFunction = 1
                if(numberOfArgInCurrentFunction == currentFunctionMaxArg)
                {
                    isFunctionComplete = true
                }
                addArgumentToFunction(text: text)
            }
            print(expressionStack)
            _ = getExpressionValue()
            return true
        }
        else if(isOprand(text:text))
        {
            if(getStackLastObjectType() == "nil" || getStackLastObjectType() == "operator" )
            {
               addOprand(text:text)
            }
            else if(getStackLastObjectType() == "oprand")
            {
                appendOprand(text:text)
            }
            else
            {
                print(expressionStack)
                _ = getExpressionValue()
                return false
            }
            print(expressionStack)
            _ = getExpressionValue()
            return true
        }
        print(expressionStack)
        _ = getExpressionValue()
        return true
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if(getStackLastObjectType() == "function")
        {
            // Ristrict user to move cursor from end of expression or from inside function
            var arbitraryValue: Int = expressionField.text.count
            if(!isFunctionComplete)
            {
                arbitraryValue = expressionField.text.count-1
            }
            let startPosition: UITextPosition = expressionField.beginningOfDocument
            var cursorPosition:Int = 0
            if let selectedRange = expressionField.selectedTextRange {
                cursorPosition = expressionField.offset(from: startPosition, to: selectedRange.start)
//                print("\(cursorPosition)")
                
            }
            if(isFunctionComplete && cursorPosition >= currentArgument.count)
            {
                if(cursorPosition > expressionField.text.count-1) // Allow cursor to move to right if function argumnet are complete eg. function(arg|) - > function(arg)|
                {
                    if let newPosition = expressionField.position(from: expressionField.beginningOfDocument, offset: cursorPosition) {
                        expressionField.selectedTextRange = expressionField.textRange(from: newPosition, to: newPosition)
                    }
                }
                else if(cursorPosition <= expressionField.text.count-currentArgument.count-2) // Ristrict cursor postion to move to left of function start eg. function(|arg) -> function|(arg)
                {
                    if let newPosition = expressionField.position(from: expressionField.beginningOfDocument, offset: cursorPosition+1) {
                        expressionField.selectedTextRange = expressionField.textRange(from: newPosition, to: newPosition)
                    }
                }
            }
            else if(cursorPosition < textView.text.count || !isFunctionComplete) // Ristrict cursor to move outside of function argument eg. function(|) -> function()| or function(|) -> function|()
            {
                if let newPosition = expressionField.position(from: expressionField.beginningOfDocument, offset: arbitraryValue) {
                    expressionField.selectedTextRange = expressionField.textRange(from: newPosition, to: newPosition)
                }
            }
        }
    }
}

extension UIView
{
    //Get Parent View Controller from any view
    func parentViewController() -> UIViewController {
        var responder: UIResponder? = self
        while !(responder is UIViewController) {
            responder = responder?.next
            if nil == responder {
                break
            }
        }
        return (responder as? UIViewController)!
    }
}

class CustomTextView: UITextView {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        UIMenuController.shared.isMenuVisible = false
        return false
    }
}
