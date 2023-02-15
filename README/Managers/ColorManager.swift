//
//  ColorManager.swift
//  README
//
//  Created by myungsun on 2023/02/15.
//

import UIKit

class ColorManager {
    static let shared = ColorManager()
    
    private init() {}
    
    func getWhite() -> UIColor {
        return UIColor(named: "White")!
    }
    
    func getCadmiumGreen() -> UIColor {
        return UIColor(named: "CadmiumGreen")!
    }
    
    func getPastelGray() -> UIColor {
        return UIColor(named: "PastelGray")!
    }
    
    func getLightSilver() -> UIColor {
        return UIColor(named: "LightSilver")!
    }
    
    func getChineseSilver() -> UIColor {
        return UIColor(named: "ChineseSilver")!
    }
    
    func getBlackOlive() -> UIColor {
        return UIColor(named: "BlackOlive")!
    }
    
    func getGray() -> UIColor {
        return UIColor(named: "Gray")!
    }
    
    func getCssGray() -> UIColor {
        return UIColor(named: "CssGray")!
    }
    
    func getChineseWhite() -> UIColor {
        return UIColor(named: "ChineseWhite")!
    }
    
    func getArgent() -> UIColor {
        return UIColor(named: "Argent")!
    }
    
    func getGraniteGray() -> UIColor {
        return UIColor(named: "GraniteGray")!
    }
    
    func getPhilippineGray() -> UIColor {
        return UIColor(named: "PhilippineGray")!
    }
}
