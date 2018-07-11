//
//  SectionController.swift
//  MojotGrad
//
//  Created by Teddy on 6/19/18.
//  Copyright © 2018 Teddy. All rights reserved.
//

import UIKit
import IGListKit

class SectionController: ListSectionController {
    
    var forecast = Forecast()
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 80)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCell(withNibName: "WeatherCollectionViewCell", bundle: nil, for: self, at: index) as! WeatherCollectionViewCell
        cell.configureCell(forecast: forecast)
        
        return cell
    }
    
    override func didUpdate(to object: Any) {
        self.forecast = object as! Forecast
    }
}
