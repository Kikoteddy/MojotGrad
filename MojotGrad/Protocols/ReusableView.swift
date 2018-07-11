//
//  ReusableView.swift
//  MojotGrad
//
//  Created by Teddy on 1/11/18.
//  Copyright © 2018 Teddy. All rights reserved.
//

import UIKit

protocol ReusableView: class{}

extension ReusableView where Self: UIView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

