//
//  Extensions.swift
//  OnboardingTutorial
//
//  Created by Stephen Dowless on 3/18/20.
//  Copyright © 2020 Stephan Dowless. All rights reserved.
//

import UIKit
import ProgressHUD

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingRight: CGFloat = 0,
                width: CGFloat? = nil,
                height: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func centerX(inView view: UIView, topAnchor: NSLayoutYAxisAnchor? = nil, paddingTop: CGFloat? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        if let topAnchor = topAnchor, let padding = paddingTop {
            self.topAnchor.constraint(equalTo: topAnchor, constant: padding).isActive = true
        }
    }
    
    
    func centerY(inView view: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil,
                 paddingLeft: CGFloat = 0, constant: CGFloat = 0) {
        
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = true
        
        if let left = leftAnchor {
            anchor(left: left, paddingLeft: paddingLeft)
        }
    }
    func centerY(inView view: UIView, constant: CGFloat = 0) {
          
          translatesAutoresizingMaskIntoConstraints = false
          centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = true
      }
    
    func centerY(inView view: UIView, rightAnchor: NSLayoutXAxisAnchor? = nil,
                  paddingRight: CGFloat = 0, constant: CGFloat = 0) {
         
         translatesAutoresizingMaskIntoConstraints = false
         centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = true
         
         if let right = rightAnchor {
             anchor(right: right, paddingRight: paddingRight)
         }
     }
    
    func setDimensions(height: CGFloat, width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    func setHeight(height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    func setWidth(width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    func fillSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        guard let superviewTopAnchor = superview?.topAnchor,
            let superviewBottomAnchor = superview?.bottomAnchor,
            let superviewLeadingAnchor = superview?.leftAnchor,
            let superviewTrailingAnchor = superview?.rightAnchor else { return }
        
        anchor(top: superviewTopAnchor, left: superviewLeadingAnchor,
               bottom: superviewBottomAnchor, right: superviewTrailingAnchor)
    }
    
   
       
       func center(inView view: UIView, yConstant: CGFloat? = 0) {
           translatesAutoresizingMaskIntoConstraints = false
           centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
           centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: yConstant!).isActive = true
       }
       
       func centerY(inView view: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil, paddingLeft: CGFloat? = nil, constant: CGFloat? = 0) {
           translatesAutoresizingMaskIntoConstraints = false
           
           centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant!).isActive = true
           
           if let leftAnchor = leftAnchor, let padding = paddingLeft {
               self.leftAnchor.constraint(equalTo: leftAnchor, constant: padding).isActive = true
           }
       }
       
       func setDimensions(width: CGFloat, height: CGFloat) {
           translatesAutoresizingMaskIntoConstraints = false
           widthAnchor.constraint(equalToConstant: width).isActive = true
           heightAnchor.constraint(equalToConstant: height).isActive = true
       }
       
       func addConstraintsToFillView(_ view: UIView) {
           translatesAutoresizingMaskIntoConstraints = false
           anchor(top: view.topAnchor, left: view.leftAnchor,
                  bottom: view.bottomAnchor, right: view.rightAnchor)
       }
    
}

// MARK: - UIColor

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }

    static let fwCyan = UIColor.rgb(red: 36, green: 189, blue: 250)
    static let fwDarkBlueBg = UIColor.rgb(red: 22, green: 27, blue: 38)
    static let fwDarkBlueFg = UIColor.rgb(red: 26, green: 32, blue: 46)
    static let fwDarkNavBar = UIColor.rgb(red: 22, green: 27, blue: 38)
    static let fwFeedBackground = UIColor(white: 0.8, alpha: 1)
    static let fwFeedCell = UIColor.rgb(red: 254, green: 255, blue: 255)
    static let fwYellow = UIColor.rgb(red: 255, green: 255, blue: 33)
    static let fwGreen = UIColor.rgb(red: 0, green: 193, blue: 33)
    static let fwFeedDarkBlue = UIColor.rgb(red: 34, green: 37, blue: 46)
    static let fwViolet = UIColor.rgb(red: 107, green: 120, blue: 221)
    static let fwMatteDarkBlue = UIColor.rgb(red: 32, green: 35, blue: 40)
    static let fwTurquoise = UIColor.rgb(red: 80, green: 196, blue: 172)
    static let fwLightPurple = UIColor.rgb(red: 244, green: 137, blue: 136)
    static let fwLightBlue = UIColor.rgb(red: 82, green: 155, blue: 194)



}


// MARK: - UIFont


extension UIFont {
    
    class func gothamBook(ofSize size: CGFloat) -> UIFont {
        
//        return UIFont.systemFont(ofSize: size, weight: .semibold)
        return UIFont(name: "Gotham-Book", size: size)!
    }
    
    class func gothamMedium(ofSize size: CGFloat) -> UIFont {
//        return UIFont.systemFont(ofSize: size, weight: .medium)

        return UIFont(name: "Gotham-Medium", size: size)!
    }
    
    class func gothamLight(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Gotham-Light", size: size)!
//        return UIFont.systemFont(ofSize: size, weight: .light)

    }
    
    class func gothamBlack(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Gotham-Black", size: size)!
//        return UIFont.systemFont(ofSize: size, weight: .black)

    }
    
    class func gothamBold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Gotham-Bold", size: size)!
//        return UIFont.systemFont(ofSize: size, weight: .bold)

    }
    
    class func gothamThin(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Gotham-Thin", size: size)!
//        return UIFont.systemFont(ofSize: size, weight: .thin)

    }
    
//    class func newRomanRegular(ofSize size: CGFloat) -> UIFont {
//        //        return UIFont(name: "Gotham-Thin", size: size)!
//        return UIFont(name: "Times New Roman Regular", size: size)!
//    }
//
//    class func newRomanBold(ofSize size: CGFloat) -> UIFont {
//        //        return UIFont(name: "Gotham-Thin", size: size)!
//        return UIFont(name: "Times New Roman", size: size)!
//    }
    }

// MARK: - UIViewController

extension UIViewController {
    func configureGradientBackground()  {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.fwDarkBlueBg.cgColor, UIColor.fwFeedDarkBlue]
        gradient.locations = [0.5, 1]
        view.layer.addSublayer(gradient)
        gradient.frame = view.frame
    }
    
    func comingSoon() {
        ProgressHUD.showSuccess("This feature in under implementation", image: #imageLiteral(resourceName: "fondwireLogo"))
    }
}

extension UIStackView {
    func addBackground(color: UIColor, withBorderColor borderColor: UIColor = .clear, borderHeight: CGFloat, andCornerRadius cornerRadius: CGFloat ) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        subView.layer.borderColor = borderColor.cgColor
        subView.layer.borderWidth = borderHeight
        subView.layer.cornerRadius = cornerRadius
        insertSubview(subView, at: 0)
    }
}


extension String {
    var youtubeID: String? {
        let pattern = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"
        
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let range = NSRange(location: 0, length: count)
        
        guard let result = regex?.firstMatch(in: self, range: range) else {
            return nil
        }
        
        return (self as NSString).substring(with: result.range)
    }
    
}
//
//extension String {
//    var htmlToAttributedString: NSAttributedString? {
//        guard let data = data(using: .utf8) else { return nil }
//        do {
//            
//            let style = NSMutableParagraphStyle()
//                 style.lineSpacing = 5
//                 style.alignment = .left
//                 style.lineBreakMode = .byWordWrapping
//                 
//                 let attributes = [NSAttributedString.Key.paragraphStyle : style,
//                                   NSAttributedString.Key.font: UIFont.gothamLight(ofSize: 14),
//                                   NSAttributedString.Key.foregroundColor: UIColor(white: 1, alpha: 1)]
//
//
//
//            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
//        } catch {
//            return nil
//        }
//    }
//    var htmlToString: String {
//        return htmlToAttributedString?.string ?? ""
//    }
//}

extension UITextView {
    func setHTMLFromString(htmlText: String) {
        let modifiedFont = String(format:"<span style=\"font-family: Avenir; color: #005CB9; font-size: \(self.font!.pointSize)\">%@</span>", htmlText)
        let attrStr = try! NSAttributedString(
            data: modifiedFont.data(using: .unicode, allowLossyConversion: true)!,
            options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue],
            documentAttributes: nil)

        self.attributedText = attrStr
    }
}


//extension UIViewController {
//    static let hud = JGProgressHUD(style: .dark)
//
//    func configureGradientBackground() {
//        let gradient = CAGradientLayer()
//        gradient.colors = [UIColor.systemPurple.cgColor, UIColor.systemBlue.cgColor]
//        gradient.locations = [0, 1]
//        view.layer.addSublayer(gradient)
//        gradient.frame = view.frame
//    }
//
//    func showLoader(_ show: Bool) {
//        view.endEditing(true)
//
//        if show {
//            UIViewController.hud.show(in: view)
//        } else {
//            UIViewController.hud.dismiss()
//        }
//    }
//
//    func showMessage(withTitle title: String, message: String) {
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//        present(alert, animated: true, completion: nil)
//    }
//}

