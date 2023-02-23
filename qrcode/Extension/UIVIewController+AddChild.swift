//
//  UIVIewController+AddChild.swift
//  ImageFilter
//
//  Created by Quang Tran on 4/12/20.
//  Copyright © 2020 Quang Tran. All rights reserved.
//

import UIKit

extension UIViewController {
    func switchToViewController(at index: Int, in view: UIView) {
        guard index < children.count else { return }
        let current = children[index]
        current.willMove(toParent: self)
        let childView: UIView = current.view
        view.addSubview(childView)
        childView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(childView.constraintsEqualToSupperView())
        current.didMove(toParent: self)
        
        for child in children.filter({$0.view.superview == view && $0 != current }) {
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.didMove(toParent: nil)
        }
    }
    
    func setViewControllers(_ viewControllers: [UIViewController], to view: UIView) {
        for child in viewControllers {
            addChild(child)
            
        }
        switchToViewController(at: 0, in: view)
    }
    
    @objc func addChild(_ child: UIViewController?, to view: UIView) {
        
        removeAllChildren(in: view)
        
        guard let child = child else { return }
        let childView: UIView = child.view
        child.willMove(toParent: self)
        
        view.addSubview(childView)
        addChild(child)
        
        
        childView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(childView.constraintsEqualToSupperView())
        
        child.didMove(toParent: self)
    }
    
    func removeAllChildren(in view: UIView) {
        for child in children(in: view) {
            child.willMove(toParent: nil)
            child.removeFromParent()
            child.view.removeFromSuperview()
            child.didMove(toParent: nil)
        }
    }
    
    func children(in view: UIView) -> [UIViewController] {
        return children.filter({$0.view.superview == view })
    }
}

