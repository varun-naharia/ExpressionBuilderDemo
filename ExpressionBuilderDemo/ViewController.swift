//
//  ViewController.swift
//  ExpressionBuilderDemo
//
//  Created by Varun Naharia on 12/12/17.
//  Copyright © 2017 Varun Naharia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var picker: UIPickerView!
    @IBOutlet var toolbar: UIToolbar!
    @IBOutlet weak var toolbarTitle: UIBarButtonItem!
    @IBOutlet weak var expressionBuilderView: VNExpressionBuilder!
    @IBOutlet weak var lblValue: UILabel!
    var arrFunctions:[[String:Any]] = [
        ["FunctionName":"MIN", "DisplayName":"MIN(e1,e2, ...)", "MinArg":2, "MaxArg":0],
        ["FunctionName":"MAX", "DisplayName":"MAX(e1, e2, ...)", "MinArg":2, "MaxArg":0],
        ["FunctionName":"ABS", "DisplayName":"ABS(expression)", "MinArg":1, "MaxArg":1],
        ["FunctionName":"ROUND", "DisplayName":"ROUND(expression, precision)", "MinArg":2, "MaxArg":2],
        ["FunctionName":"FLOOR", "DisplayName":"FLOOR(expression)", "MinArg":1, "MaxArg":1],
        ["FunctionName":"CEILING", "DisplayName":"CEILING(expression)", "MinArg":1, "MaxArg":1],
        ["FunctionName":"LOG", "DisplayName":"LOG(expression)", "MinArg":1, "MaxArg":1],
        ["FunctionName":"LOG10", "DisplayName":"LOG10(expression)", "MinArg":1, "MaxArg":1],
        ["FunctionName":"SQRT", "DisplayName":"SQRT(expression)", "MinArg":1, "MaxArg":1],
        ["FunctionName":"SIN", "DisplayName":"SIN(expression)", "MinArg":1, "MaxArg":1],
        ["FunctionName":"COS", "DisplayName":"COS(expression)", "MinArg":1, "MaxArg":1],
        ["FunctionName":"TAN", "DisplayName":"TAN(expression)", "MinArg":1, "MaxArg":1],
        ["FunctionName":"COT", "DisplayName":"COT(expression)", "MinArg":1, "MaxArg":1],
        ["FunctionName":"ASIN", "DisplayName":"ASIN(expression)", "MinArg":1, "MaxArg":1],
        ["FunctionName":"ACOS", "DisplayName":"ACOS(expression)", "MinArg":1, "MaxArg":1],
        ["FunctionName":"ATAN", "DisplayName":"ATAN(expression)", "MinArg":1, "MaxArg":1],
        ["FunctionName":"ACOT", "DisplayName":"ACOT(expression)", "MinArg":1, "MaxArg":1],
        ["FunctionName":"ATAN2", "DisplayName":"ATAN2(y,x)", "MinArg":2, "MaxArg":2],
        ["FunctionName":"SINH", "DisplayName":"SINH(expression)", "MinArg":1, "MaxArg":1],
        ["FunctionName":"COSH", "DisplayName":"COSH(expression)", "MinArg":1, "MaxArg":1],
        ["FunctionName":"TANH", "DisplayName":"TANH(expression)", "MinArg":1, "MaxArg":1],
        ["FunctionName":"COTH", "DisplayName":"COTH(expression)", "MinArg":1, "MaxArg":1],
        ["FunctionName":"SEC", "DisplayName":"SEC(expression)", "MinArg":1, "MaxArg":1],
        ["FunctionName":"CSC", "DisplayName":"CSC(expression)", "MinArg":1, "MaxArg":1],
        ["FunctionName":"SECH", "DisplayName":"SECH(expression)", "MinArg":1, "MaxArg":1],
        ["FunctionName":"CSCH", "DisplayName":"CSCH(expression)", "MinArg":1, "MaxArg":1],
        ["FunctionName":"ASINH", "DisplayName":"ASINH(expression)", "MinArg":1, "MaxArg":1],
        ["FunctionName":"ACOSH", "DisplayName":"ACOSH(expression)", "MinArg":1, "MaxArg":1],
        ["FunctionName":"ATANH", "DisplayName":"ATANH(expression)", "MinArg":1, "MaxArg":1],
        ["FunctionName":"RAD", "DisplayName":"RAD(expression)", "MinArg":1, "MaxArg":1],
        ["FunctionName":"DEG", "DisplayName":"DEG(expression)", "MinArg":1, "MaxArg":1]
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        expressionBuilderView.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        picker.delegate = nil
        picker.dataSource = nil
        expressionBuilderView.expressionField.inputView = nil
        expressionBuilderView.expressionField.resignFirstResponder()
    }
    
    @IBAction func doneAction(_ sender: UIBarButtonItem) {
       
//        expressionBuilderView.expressionField.text = arrFunctions[picker.selectedRow(inComponent: 0)]
        expressionBuilderView.addFunction(functionName: arrFunctions[picker.selectedRow(inComponent: 0)]["FunctionName"] as! String, minArg: arrFunctions[picker.selectedRow(inComponent: 0)]["MinArg"] as! Int, maxArg: arrFunctions[picker.selectedRow(inComponent: 0)]["MaxArg"] as! Int)
        expressionBuilderView.expressionField.resignFirstResponder()
        removeDoneButtonOnKeyboard()
        picker.delegate = nil
        picker.dataSource = nil
        expressionBuilderView.expressionField.inputView = nil
    }
    
    @IBAction func functionAction(_ sender: UIButton) {
        picker.delegate = self
        picker.dataSource = self
        expressionBuilderView.expressionField.inputView = picker
        self.addDoneButtonOnKeyboard()
        expressionBuilderView.expressionField.becomeFirstResponder()
        removeDoneButtonOnKeyboard()
    }
    
    @IBAction func expressionAction(_ sender: UIButton) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func evaluateAction(_ sender: UIButton) {
        lblValue.text = expressionBuilderView.getExpressionValue()
    }
}

extension ViewController:UIPickerViewDelegate, UIPickerViewDataSource
{
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        toolbarTitle.title = "Function"
        return arrFunctions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrFunctions[row]["DisplayName"] as? String
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        expressionBuilderView.addFunction(functionName: arrFunctions[row]["FunctionName"] as! String, minArg: arrFunctions[row]["MinArg"] as! Int, maxArg: arrFunctions[row]["MaxArg"] as! Int)
    }
    func addDoneButtonOnKeyboard()
    {
        expressionBuilderView.expressionField.inputAccessoryView = toolbar
    }
    
    func removeDoneButtonOnKeyboard()
    {
        expressionBuilderView.expressionField.inputAccessoryView = nil
    }
    
}

extension ViewController:VNExpressionBuilderDelegate
{
    func expressionValueChanged(value: String) {
        lblValue.text = value
    }
}

