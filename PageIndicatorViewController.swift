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
    fileprivate var arrangedViews = [UIView]()
    fileprivate var selectorView = UIView()
    
    fileprivate var didSetupViews = false
    
    convenience init(pages: Int, initialPageIndex: Int) {
        self.init()
        self.pages = pages
        self.currentPageIndex = initialPageIndex
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupViews()
    }
    
    fileprivate func setupViews() {
        guard !self.didSetupViews else { return }
        self.didSetupViews = true
        
        self.view.backgroundColor = UIColor.red.withAlphaComponent(0.2)

        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.translatesAutoresizingMaskIntoConstraints = false

        for _ in 0...self.pages {
            let view = UIView()
            view.widthAnchor.constraint(equalToConstant: 14).isActive = true
            view.heightAnchor.constraint(equalToConstant: 14).isActive = true
            view.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            view.layer.cornerRadius = 7
            view.clipsToBounds = true
            self.arrangedViews.append(view)
            stackView.addArrangedSubview(view)
        }
        
        self.view.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        self.selectorView = UIView(frame: CGRect(x: 0, y: 0, width: 21, height: 21))
        self.selectorView.widthAnchor.constraint(equalToConstant: 21).isActive = true
        self.selectorView.heightAnchor.constraint(equalToConstant: 21).isActive = true
        self.selectorView.backgroundColor = .white
        self.selectorView.layer.cornerRadius = 10.5
        self.selectorView.clipsToBounds = true
        
        self.view.addSubview(self.selectorView)
        goToPage(self.currentPageIndex)
        
    }

}

// MARK: - Public Functions
extension PageIndicatorViewController {
    
    public func nextPage() {
        
    }
    
    public func previousPage() {
        
    }
    
    public func goToPage(_ page: Int) {
        let view = self.arrangedViews[page]
        let xPosition = view.frame.midX
        let yPosition = view.frame.midY
        
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            self.selectorView.center = CGPoint(x: xPosition, y: yPosition)
        }) { (_) in
            
        }
    }
    
}
