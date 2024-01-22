//
//  ViewController.swift
//  ScrollViewPractice
//
//  Created by Chorrs on 6.01.24.
//

import UIKit

final class ViewController: UIViewController {

    private let pictureToZoom = "https://arthive.net/res/media/img/oy1200/work/aa9/333910@2x.webp"
    
    // вью, которое будет возвращаться при зуминге в функции viewForZooming
    private var zoomingView: UIImageView?
    
    @IBOutlet weak var scrollViewOutlet: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollViewOutlet.delegate = self
        
        gettingOf(pictureToZoom: pictureToZoom)
    }

    // MARK: Actions
    @IBAction func actionHandler(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            scrollViewOutlet.setContentOffset(CGPoint.zero, animated: true)
        case 1:
            scrollToPart(partNumber: 1)
        case 2:
            scrollToPart(partNumber: 2)
        default:
            break
        }
    }
    
    func scrollToPart(partNumber: Int) {
        guard let imageView = zoomingView else {
            return
        }
        let totalParts = 3
        let partWidth = imageView.bounds.width / CGFloat(totalParts)
        let xOffset = CGFloat(partNumber) * partWidth

        scrollViewOutlet.setContentOffset(CGPoint(x: xOffset, y: 0), animated: true)
    }
    
    func gettingOf(pictureToZoom: String) {
        //         1) получаем URL из строки
        //         2) по URL скачали данные в виде байт
        //         3) преобразовали эти байт в картинку
        DispatchQueue.global().async {
            if let url = URL(string: pictureToZoom),
               let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                
                DispatchQueue.main.async {
                    let imageView = UIImageView(image: image)
                    self.zoomingView = imageView
                    self.scrollViewOutlet.addSubview(imageView)
                    
                    self.scrollViewOutlet.contentSize = image.size
                    self.scrollViewOutlet.minimumZoomScale = 0.01
                    self.scrollViewOutlet.maximumZoomScale = 2
                }
            }
        }
    }
}


extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("Scroll happend.")
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return zoomingView
    }
}

