//
//  listImages.swift
//  scrollView
//
//  Created by Pham Ngoc Hai on 12/1/16.
//  Copyright © 2016 pnh. All rights reserved.
//

import UIKit

class listImages: UIViewController {
    
    @IBAction func onTouch(_ sender: AnyObject) {
        switch (sender.tag) {
            
        case 101 : pushView(Index: 0)
        case 102 : pushView(Index: 1)
        case 103 : pushView(Index: 2)
        default : break
        }
        
    }
    func pushView(Index: Int)
    {
        let listView = self.storyboard?.instantiateViewController(withIdentifier: "viewScroll") as? scrollView
        listView?.currentImgView = Index
        self.navigationController?.pushViewController(listView!, animated: true)
        
    }
}
