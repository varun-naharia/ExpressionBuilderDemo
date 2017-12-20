//
//  MathFunctions.swift
//  ExpressionBuilderDemo
//
//  Created by Varun Naharia on 14/12/17.
//  Copyright © 2017 Varun Naharia. All rights reserved.
//

import UIKit

class MathFunctions: NSObject {
    
    class func MIN(args:[Double]) -> Double {
        return args.min()!
    }
    
    class func MAX(args:[Double]) -> Double {
        return args.max()!
    }
    
    class func ABS(arg:Double) -> Double {
        return abs(arg)
    }
    
    class func ROUND(arg:Double, precision:Int) -> Double {
        let divisor = pow(10.0, Double(precision))
        return (arg * divisor).rounded() / divisor
    }
    
    class func FLOOR(arg:Double) -> Double {
        return floor(arg)
    }
    
    class func CEILING(arg:Double) -> Double {
        return ceil(arg)
    }
    
    class func LOG(arg:Double) -> Double {
        return log(arg)
    }
    
    class func LOG10(arg:Double) -> Double {
        return log10(arg)
    }
    
    class func SQRT(arg:Double) -> Double {
        return sqrt(arg)
    }
    
    class func SIN(arg:Double) -> Double {
        return sin(arg)
    }
    
    class func COS(arg:Double) -> Double {
        return cos(arg)
    }
    
    class func TAN(arg:Double) -> Double {
        return tan(arg)
    }
    
    class func CSC(arg:Double) -> Double {
        return 1/sin(arg)
    }
    
    class func SEC(arg:Double) -> Double {
        return 1/cos(arg)
    }

    class func COT(arg:Double) -> Double {
        return 1/tan(arg)
    }
    
    class func ASIN(arg:Double) -> Double {
        return asin(arg)
    }
    
    class func ACOS(arg:Double) -> Double {
        return 1/tan(arg)
    }
    
    class func ATAN(arg:Double) -> Double {
        return 1/tan(arg)
    }
    
    class func ACOT(arg:Double) -> Double {
        return 1/tan(arg)
    }
    
    class func ATAN2(arg:Double) -> Double {
        return atan(arg)
    }
    
    class func SINH(arg:Double) -> Double {
        return sinh(arg)
    }
    
    class func COSH(arg:Double) -> Double {
        return cosh(arg)
    }
    
    class func TANH(arg:Double) -> Double {
        return tanh(arg)
    }
    
    class func COTH(arg:Double) -> Double {
        return 1/tanh(arg)
    }
    
    class func SECH(arg:Double) -> Double {
        return 1/cosh(arg)
    }
    
    class func CSCH(arg:Double) -> Double {
        return 1/sinh(arg)
    }
    
    class func ASINH(arg:Double) -> Double {
        return 1/sinh(arg)
    }
    
    class func ACOSH(arg:Double) -> Double {
        return 1/cosh(arg)
    }
    
    class func ATANH(arg:Double) -> Double {
        return 1/tanh(arg)
    }
    
    class func RAD(arg:Double) -> Double {
        return  arg * 180 / .pi
    }
    
    class func DEG(arg:Double) -> Double {
        return arg * .pi / 180
    }

}
