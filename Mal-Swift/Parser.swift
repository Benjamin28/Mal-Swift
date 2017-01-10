//
//  Parser.swift
//  Mal-Swift
//
//  Created by test on 1/6/17.
//  MIT License
//

import Foundation


public class Parser {
    
    private var numChars = "0123456789."
    private var function: Array<Any>
    private var cursor: Int
    private var domain: [Float64]
    private var range:  [Float64]
    
    init(functionString: String) {
        self.function = Array(functionString.characters)
        self.cursor = 0
        self.domain = Array()
        self.range = Array()
        
    }
    
    private func isNum() -> Bool{
        return numChars.contains(String(describing: function[cursor]))
    }
    
    private func parserGetNum() -> Float64{
        
        var s: String = ""
        var c: Int = self.cursor
        while(numChars.contains(String(describing: self.function[c]))){
            s.append(String(describing: self.function[c]))
            c += 1
        }
        return Float64(s)!
    }
    
    private func parserIncrimentCursor(){
        
        if isNum(){
            while(isNum()){
                self.cursor += 1
            }
        }
        else{
            self.cursor += 1
        }
        if(self.cursor == function.count){
            return
        }
        while(String(describing: function[cursor]) == " "){
            self.cursor += 1 
        }
    }
    
    private func parserHighPriority() -> [Float64] {
        
        let indicator = String(describing: self.function[self.cursor])
        var resultList: [Float64] = Array()
        
        if(indicator == "x" || indicator == "X"){
            
            for x in self.domain{
                resultList.append(x)
            }
            parserIncrimentCursor()
            return resultList
        }
        if(isNum()){
            
            let n: Float64 = parserGetNum()
            for _ in 0..<self.domain.count{
                resultList.append(n)
            }
            parserIncrimentCursor()
            return resultList
        }
        return resultList
    }
    
    private func parserMedPriority() -> [Float64]{
        
        var highPrioLeft: [Float64] = parserHighPriority()
        
        while(self.cursor < function.count && String(describing: self.function[self.cursor]) == "*"){
            parserIncrimentCursor()
            var highPrioRight: [Float64] = parserHighPriority()
            for i in 0..<self.domain.count{
                
                highPrioLeft[i] *= highPrioRight[i]
            }
        }
        return highPrioLeft
    }
    
    private func parserLowPriority() -> [Float64]{
        
        var medPrioLeft: [Float64] = parserMedPriority()
        
        while(self.cursor < function.count && String(describing: self.function[self.cursor]) == "+"){
            
            parserIncrimentCursor()
            var medPrioRight: [Float64] = parserMedPriority()
            for i in 0..<self.domain.count{
                
                medPrioLeft[i] += medPrioRight[i]
            }
        }
        return medPrioLeft
    }
    
    private func parserExpression() -> [Float64]{
        
        return parserLowPriority()
    }
    
    public func parserPlot(start: Float64, end: Float64, totalSteps: Int){

        parserGenDomain(start: start, end: end, steps: totalSteps)
        self.range = parserExpression()
    }
    
    public func parserGenDomain(start: Float64, end: Float64, steps: Int){
        
        var domainArray: [Float64] = Array()
        let stepSize: Float64 = (end-start)/Float64(steps)
        var current: Float64 = start
        
        while(current<end){
            domainArray.append(current)
            current+=stepSize
        }
        self.domain = domainArray
    }
    
    public func getX() -> [Float64]{
        return self.domain
    }
    public func getY() -> [Float64]{
        return self.range
    }
    
}
