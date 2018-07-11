//
//  UITableView+Ext.swift
//  MojotGrad
//
//  Created by Teddy on 1/11/18.
//  Copyright © 2018 Teddy. All rights reserved.
//

import UIKit

extension UITableView {
    
    func register<T: UITableViewCell>(_ T:T.Type) where T: NibLoadableView {
        let nib = UINib(nibName: T.nibName, bundle: nil)
        register(nib, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeReusableCell<T: UITableViewCell>(forIndexPath indexPath: NSIndexPath) -> T   {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath as IndexPath) as? T else {
            fatalError("Could not deque cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
}

extension UITableViewCell: ReusableView {}
