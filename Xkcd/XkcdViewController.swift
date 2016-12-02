//
//  XkcdViewController.swift
//  Xkcd
//
//  Created by Eric Chang on 12/1/16.
//  Copyright © 2016 Eric Chang. All rights reserved.
//

import UIKit
import View2ViewTransition

var ourImage: [UIImage] = []
var comic: [Comic] = []
var currentComic = 1766

class XkcdViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var testLabel: UILabel!
    
    let apiClient = APIManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        self.view.addSubview(self.collectionView)
    }
    
    func loadImage(url: URL) {
        let shareSession = URLSession.shared
        let downloadTask = shareSession.downloadTask(with: url, completionHandler: { (location: URL?, response: URLResponse?, error: Error?) -> Void in
            if location != nil {
                DispatchQueue.main.async {
                    let data:Data! = try? Data(contentsOf: location!)
                    let image = UIImage(data: data)
                    ourImage.append(image!)
                    if ourImage.count == comic.count {
                        self.collectionView.reloadData()
                    }
                }
            }
        })
        downloadTask.resume()
    }
    
    
    let transitionController: TransitionController = TransitionController()
    
    var selectedIndexPath: IndexPath = IndexPath(item: 0, section: 0)
    
    lazy var collectionView: UICollectionView = {
        
        let lendth: CGFloat = (UIScreen.main.bounds.size.width - 4.0)/3.0
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: lendth, height: lendth)
        layout.minimumLineSpacing = 1.0
        layout.minimumInteritemSpacing = 1.0
        layout.scrollDirection = .vertical
        
        let collectionView: UICollectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.register(PresentingCollectionViewCell.self, forCellWithReuseIdentifier: "presenting_cell")
        collectionView.backgroundColor = UIColor.white
        collectionView.contentInset = UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    lazy var titleLabel: UILabel = {
        let font: UIFont = UIFont(name: "Futura-Medium", size: 16.0)!
        let label: UILabel = UILabel()
        label.font = font
        label.text = "All"
        label.sizeToFit()
        return label
    }()
    
    lazy var closeItem: UIBarButtonItem = {
        let item: UIBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(onCloseButtonClicked(sender:)))
        return item
    }()
    
    // MARK: CollectionView Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.selectedIndexPath = indexPath
        
        let presentedViewController: PresentedViewController = PresentedViewController()
        
        presentedViewController.transitionController = self.transitionController
        transitionController.userInfo = ["destinationIndexPath": indexPath as NSIndexPath, "initialIndexPath": indexPath as NSIndexPath]
        
        // This example will push view controller if presenting view controller has navigation controller.
        // Otherwise, present another view controller
        if let navigationController = self.navigationController {
            
            // Set transitionController as a navigation controller delegate and push.
            navigationController.delegate = transitionController
            transitionController.push(viewController: presentedViewController, on: self, attached: presentedViewController)
            
        } else {
            
            // Set transitionController as a transition delegate and present.
            presentedViewController.transitioningDelegate = transitionController
            transitionController.present(viewController: presentedViewController, on: self, attached: presentedViewController, completion: nil)
        }
        
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if let _ = self.navigationController { return }
        
        if scrollView.contentOffset.y <= -100.0 {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: CollectionView Data Source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comic.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: PresentingCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "presenting_cell", for: indexPath) as! PresentingCollectionViewCell
        cell.contentView.backgroundColor = UIColor.lightGray
        //let number: Int = indexPath.item%4 + 1
        cell.content.image = ourImage[indexPath.row]
        
        return cell
    }
    
    // MARK: Actions
    
    func onCloseButtonClicked(sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func loadData() {
                for i in 0...50 {
                    self.apiClient.getData(index: String(currentComic - i), completionHandler: { response in
                        DispatchQueue.main.async {
                            if let response = response {
                                comic.append(response)
                                self.loadImage(url: URL(string: (response.image))!)
                            }
                        }
                    })
                }
        
        
//        if currentComic == 0 {
//            apiClient.getData(completionHandler: { results in
//                DispatchQueue.main.async {
//                    if let results = results {
//                        comic.append(results)
//                        currentComic = results.id
//                        print("\n\n\n\(currentComic)")
//                        self.loadOtherData()
//                    }
//                }
//            })
//        }
//    }
//    func loadOtherData() {
//        for i in 0...50 {
//            self.apiClient.getData(index: String(currentComic - i), completionHandler: { response in
//                DispatchQueue.main.async {
//                    if let response = response {
//                        comic.append(response)
//                        self.loadImage(url: URL(string: (response.image))!)
//                    }
//                }
//            })
//        }
    }
}

// MARK: - Funky stuff

extension XkcdViewController: View2ViewTransitionPresenting {
    
    func initialFrame(_ userInfo: [String: AnyObject]?, isPresenting: Bool) -> CGRect {
        
        guard let indexPath: IndexPath = userInfo?["initialIndexPath"] as? IndexPath, let attributes: UICollectionViewLayoutAttributes = self.collectionView.layoutAttributesForItem(at: indexPath) else {
            return CGRect.zero
        }
        return self.collectionView.convert(attributes.frame, to: self.collectionView.superview)
    }
    
    func initialView(_ userInfo: [String: AnyObject]?, isPresenting: Bool) -> UIView {
        
        let indexPath: IndexPath = userInfo!["initialIndexPath"] as! IndexPath
        let cell: UICollectionViewCell = self.collectionView.cellForItem(at: indexPath)!
        
        return cell.contentView
    }
    
    func prepareInitialView(_ userInfo: [String : AnyObject]?, isPresenting: Bool) {
        let indexPath: IndexPath = userInfo!["initialIndexPath"] as! IndexPath
        
        if !isPresenting && !self.collectionView.indexPathsForVisibleItems.contains(indexPath) {
            self.collectionView.reloadData()
            self.collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: false)
            self.collectionView.layoutIfNeeded()
        }
    }
}

public class PresentingCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.content)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public lazy var content: UIImageView = {
        let view: UIImageView = UIImageView(frame: self.contentView.bounds)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.backgroundColor = UIColor.gray
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
}
