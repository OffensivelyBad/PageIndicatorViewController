//
//  TSPageIndicatorViewController.swift
//  iWMS 2
//
//  Created by Shawn Roller on 1/30/18.
//  Copyright © 2018 JustFab. All rights reserved.
//

import UIKit

class PageIndicatorViewController: UIViewController {
    
    fileprivate var pages = 0
    fileprivate var currentPageIndex = 0
    fileprivate var indicatorColors: [UIColor] = []
    fileprivate var selectorView = UIView()
    fileprivate var stackView = UIStackView()
    fileprivate var viewsWereSetup = false
    
    // Customizable properties
    public var unselectedIndicatorSize: CGFloat = 14
    public var selectedIndicatorSize: CGFloat = 22
    public var selectorSecondaryColor: UIColor = UIColor.white.withAlphaComponent(0.8)
    
    convenience init(pages: Int, initialPageIndex: Int, indicatorColors: [UIColor]?) {
        self.init()
        self.pages = pages
        self.currentPageIndex = initialPageIndex
        if let colors = indicatorColors, colors.count == pages {
            self.indicatorColors = colors
        } else {
            // Set the indicator colors to white by default
            self.indicatorColors = Array(repeating: UIColor.white, count: pages)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !self.viewsWereSetup {
            self.viewsWereSetup = true
            setupViews()
        }
    }
    
    fileprivate func setupViews() {
        self.view.backgroundColor = .clear
        
        // Create a stack view to hold the page indicators
        self.stackView = UIStackView()
        self.stackView.axis = .horizontal
        self.stackView.alignment = .bottom
        self.stackView.distribution = .equalCentering
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add dots for the appropriate nubmer of pages
        for i in 0..<self.pages {
            let view = UIView()
            let color = self.indicatorColors[i]
            view.widthAnchor.constraint(equalToConstant: self.unselectedIndicatorSize).isActive = true
            view.heightAnchor.constraint(equalToConstant: self.unselectedIndicatorSize).isActive = true
            view.backgroundColor = color
            view.layer.cornerRadius = self.unselectedIndicatorSize / 2
            view.clipsToBounds = true
            self.stackView.addArrangedSubview(view)
        }
        
        self.view.addSubview(self.stackView)
        self.stackView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.stackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        // Create the selector dot that hovers over the selected page indicator
        self.selectorView = UIView(frame: CGRect(x: 0, y: 0, width: self.selectedIndicatorSize, height: self.selectedIndicatorSize))
        self.selectorView.widthAnchor.constraint(equalToConstant: self.selectedIndicatorSize).isActive = true
        self.selectorView.heightAnchor.constraint(equalToConstant: self.selectedIndicatorSize).isActive = true
        self.selectorView.backgroundColor = .white
        self.selectorView.layer.cornerRadius = self.selectedIndicatorSize / 2
        self.selectorView.clipsToBounds = true
        
        // Add a ring around the selector
        let stepColor = self.indicatorColors[self.currentPageIndex]
        let layer = CAShapeLayer()
        let path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: self.selectedIndicatorSize, height: self.selectedIndicatorSize))
        layer.path = path.cgPath
        layer.strokeColor = self.selectorSecondaryColor.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = 10
        self.selectorView.layer.addSublayer(layer)
        self.selectorView.layer.borderWidth = 2
        self.selectorView.layer.borderColor = stepColor.cgColor
        
        self.view.addSubview(self.selectorView)
        
        // Go to the initial page
        goToPage(self.currentPageIndex)
        
    }
    
    /*
     -(void)drawRect:(CGRect)frame
     {
     UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(CGRectGetMinX(frame) + 2, CGRectGetMinY(frame) + 2.5, CGRectGetWidth(frame) - 5, CGRectGetHeight(frame) - 5)];
     [UIColor.redColor setStroke];
     ovalPath.lineWidth = 1;
     [ovalPath stroke];
     
     UIBezierPath* oval2Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(CGRectGetMinX(frame) + 10, CGRectGetMinY(frame) + 10, CGRectGetWidth(frame) - 20, CGRectGetHeight(frame) - 20)];
     [UIColor.lightGrayColor setFill];
     [oval2Path fill];
     }
     */
    
}

// MARK: - Public Functions
extension PageIndicatorViewController {
    
    public func nextPage() {
        if self.currentPageIndex + 1 >= self.stackView.arrangedSubviews.count {
            self.currentPageIndex = 0
        }
        else {
            self.currentPageIndex += 1
        }
        
        goToPage(self.currentPageIndex)
    }
    
    public func previousPage() {
        if self.currentPageIndex - 1 >= 0 {
            self.currentPageIndex = self.stackView.arrangedSubviews.count - 1
        }
        else {
            self.currentPageIndex -= 1
        }
        
        goToPage(self.currentPageIndex)
    }
    
    public func goToPage(_ page: Int) {
        
        guard page < self.stackView.arrangedSubviews.count else { return }
        
        // Ensure the subview frames are set
        self.stackView.layoutIfNeeded()
        
        // Get the mid point of the page indicator view
        let view = self.stackView.arrangedSubviews[page]
        let x = view.frame.midX
        let y = view.frame.midY
        let color = self.indicatorColors[page].cgColor
        
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            self.selectorView.center = CGPoint(x: x, y: y)
            self.selectorView.layer.borderColor = color
            self.selectorView.layer.backgroundColor = color
        }) { (_) in
            
        }
        
    }
    
}

