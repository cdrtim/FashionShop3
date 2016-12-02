//
//  scrollView.swift
//  scrollView
//
//  Created by Pham Ngoc Hai on 11/28/16.
//  Copyright © 2016 pnh. All rights reserved.
//

import UIKit

class scrollView: UIViewController    {
    @IBOutlet weak var pageController: UIPageControl!
    var frontScrollView: [UIScrollView] = []
    var pageImages: [String] = []
    var pageViews: [UIImageView?] = []
    var currentImgView = 0
    var first = false
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        pageImages = ["shop1-0.jpg", "shop1-1.jpg", "shop1-2.jpg"]
        pageController.currentPage = currentImgView
        pageController.numberOfPages = pageImages.count
        scrollView.minimumZoomScale = 0.5
        scrollView.maximumZoomScale = 2.0
    }
    
    
    @IBAction func backNextButton(_ sender: UIButton) {
        switch (sender.tag) {
            
        case 101 :
            
            /* nếu page hiện tại khác tổng số page thì page hiện tại + 1
             contentOffSet để load ảnh vào view
             */
            if(pageController.currentPage != pageController.numberOfPages){
                pageController.currentPage += 1
                scrollView.contentOffset = CGPoint(x: CGFloat(pageController.currentPage) * frontScrollView[pageController.currentPage].frame.size.width, y: 0)
            }
        case 102 :
            if(pageController.currentPage != 0){
                pageController.currentPage -= 1
                scrollView.contentOffset = CGPoint(x: CGFloat(pageController.currentPage) * frontScrollView[pageController.currentPage].frame.size.width, y: 0)}
        default : break
        }
        
        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        if (!first)
        {
            first = true
            // 4
            let pagesScrollViewSize = scrollView.frame.size
            scrollView.contentSize = CGSize(width: pagesScrollViewSize.width * CGFloat(pageImages.count), height: 0)
            scrollView.contentOffset = CGPoint(x: CGFloat(currentImgView) * scrollView.frame.size.width, y: 0)
            // 5
            for i in 0 ..< pageImages.count
            {
                let imgView = UIImageView(image: UIImage(named:pageImages[i]+".jpg"))
                imgView.frame = CGRect(x: 0, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height)
                imgView.contentMode = .scaleAspectFit
                imgView.isUserInteractionEnabled = true
                imgView.isMultipleTouchEnabled = true
                
                let tap = UITapGestureRecognizer(target: self, action: #selector(tapImg(_:)))
                tap.numberOfTapsRequired = 1
                imgView.addGestureRecognizer(tap)
                let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTabImg(_:)))
                doubleTap.numberOfTapsRequired = 2
                imgView.addGestureRecognizer(doubleTap)
                tap.require(toFail: doubleTap)
                pageViews.append(imgView)
                
                
                let frontScrollView1 = UIScrollView(frame: CGRect( x: CGFloat(i) * scrollView.frame.size.width, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height))
                frontScrollView1.minimumZoomScale = 1
                frontScrollView1.maximumZoomScale = 2
                frontScrollView1.delegate = self
                frontScrollView1.contentSize = imgView.bounds.size
                frontScrollView1.addSubview(imgView)
                frontScrollView.append(frontScrollView1)
                self.scrollView.addSubview(frontScrollView1)
            }
            
        }
    }
    
    func tapImg(_ gesture: UITapGestureRecognizer)
    {
        let position = gesture.location(in: pageViews[pageController.currentPage])
        zoomRectForScale(scrollView.zoomScale * 1.5, center: position)
    }
    func doubleTabImg(_ gesture: UITapGestureRecognizer)
    {
        let position = gesture.location(in: pageViews[pageController.currentPage])
        zoomRectForScale(scrollView.zoomScale * 0.5, center: position)
    }
    func zoomRectForScale(_ scale: CGFloat, center: CGPoint)
    {
        var zoomRect = CGRect()
        let scrollViewSize = scrollView.bounds.size
        zoomRect.size.height = scrollViewSize.height / scale
        zoomRect.size.width = scrollViewSize.width / scale
        
        zoomRect.origin.x = center.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0)
        frontScrollView[pageController.currentPage].zoom(to: zoomRect, animated: true)
    }
    
}
extension scrollView: UIScrollViewDelegate
{
    //uiscrollview delegate
    func viewForZooming(in scrollView: UIScrollView) -> UIView?
    {
        return pageViews[pageController.currentPage]
    }
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat)
    {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((self.scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        if (pageController.currentPage != page)
        {
            //   frontScrollView[pageController.currentPage].zoomScale = 1
            pageController.currentPage = page
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
    }
}
