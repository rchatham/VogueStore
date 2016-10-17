//
//  HomeViewController.swift
//  VogueStore
//
//  Created by Reid Chatham on 10/14/16.
//  Copyright © 2016 Reid Chatham. All rights reserved.
//

import UIKit
import ionicons

class HomeViewController: UIViewController, NavBarCustomizeable {
    
    @IBAction func shopButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "startShopping", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // 1. Construct navigation bar
        // 2. Call Api
        // 3. Format views
        
        let tint = AppDelegate.Static.tint
        
        let leftImage = IonIcons.image(withIcon: ion_navicon, iconColor: tint, iconSize: 50, imageSize: CGSize(width: 40, height: 40))
        let leftItems = [UIBarButtonItem(image: leftImage, style: .plain, target: nil, action: nil)]
        
        let titleView = UIImageView(image: UIImage(named: "vogue-title"))
        titleView.frame = CGRect(x: 0, y: 0, width: 91, height: 25)
        titleView.contentMode = .scaleAspectFit
        
        let rightImage = IonIcons.image(withIcon: ion_ios_person, iconColor: tint, iconSize: 50, imageSize: CGSize(width: 40, height: 40))
        let rightItems = [UIBarButtonItem(image: rightImage, style: .plain, target: nil, action: nil)]
        
        customNavigationBar = styleNavBar(leftItems: leftItems, titleView: titleView, rightItems: rightItems)
        
        callApiEndpoint { (pts) in
            self.points = pts
        }
        
        formatViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        _ = onceScroller
    }
    
    // MARK: - Fileprivate
    
    fileprivate var indicators: [UIView] {
        return [
            page1Indicator,
            page2Indicator,
            page3Indicator,
            page4Indicator
        ]
    }
    
    // MARK: - Private
    
    private lazy var onceScroller: Void = {
        let start = IndexPath(item: 1, section: 0)
        self.collectionView?.scrollToItem(at: start, at: .centeredHorizontally, animated: false)
    }()
    
    private var customNavigationBar: UINavigationBar!
    
    private var newOffers: Int = 0 {
        didSet {
            let formatter = NumberFormatter()
            formatter.usesGroupingSeparator = true
            let numberString = formatter.string(from: NSNumber(integerLiteral: newOffers))
            var text = "\(numberString) new offer"
            if newOffers != 1 {
                text = text + "s"
            }
            offersLabel?.text = text
        }
    }
    
    private var points: Int = 0 {
        didSet {
            let formatter = NumberFormatter()
            formatter.usesGroupingSeparator = true
            formatter.groupingSize = 3
            formatter.groupingSeparator = ","
            let numberString = formatter.string(from: NSNumber(integerLiteral: points))!
            pointsLabel?.text = "\(numberString) pts."
        }
    }
    
    private var userOptionViews: [UIView] {
        return [
            shopView,
            eventsView,
            personalShopperView,
            offersView,
            loyaltyPointsView
        ]
    }
    
    // Call API for loyalty points from endpoint and return the result if the call succeeds.
    private func callApiEndpoint(_ callback: @escaping (Int)->Void) {
        
        let url = URL(string: "http://54.191.35.66:8181/pfchang/api/buy?username=Michael&grandTotal=0")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let data = data else {
                print("No data!")
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:Any]
                
                guard let pts = json["rewardPoints"] as? Int else {
                    print("failed to parse json")
                    return
                }
                DispatchQueue.main.async {
                    callback(pts)
                }
                
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    // Format views with appropriate layer shadows and other details
    private func formatViews() {
        
        for indicator in indicators {

            indicator.layoutIfNeeded()
            indicator.layer.cornerRadius = indicator.frame.width/2
            
            indicator.backgroundColor = .white
            indicator.layer.shadowOffset = CGSize(width: -1, height: 1)
            indicator.layer.shadowColor = UIColor.black.cgColor
            indicator.layer.shadowOpacity = 0.5
            indicator.layer.shadowRadius = 2.0
            indicator.layer.borderWidth = 2
            indicator.layer.borderColor = UIColor.white.cgColor
        }
        indicators[0].backgroundColor = AppDelegate.Static.tint
        
        for option in userOptionViews {
            option.layer.shadowOffset = CGSize(width: -1, height: 1)
            option.layer.shadowColor = UIColor.black.cgColor
            option.layer.shadowOpacity = 0.5
            option.layer.shadowRadius = 2.0
        }
        
        shopIcon?.image = IonIcons.image(withIcon: ion_ios_cart, size: 27, color: .white)
        eventsIcon?.image = IonIcons.image(withIcon: ion_calendar, size: 21, color: .white)
        personalShopperIcon?.image = IonIcons.image(withIcon: ion_bag, size: 21, color: .white)
        offersIcon?.image = IonIcons.image(withIcon: ion_pricetag, size: 27, color: .white)
        loyaltyPointsIcon?.image = IonIcons.image(withIcon: ion_trophy, size: 21, color: .white)
    }
    
    // MARK: - IBOutlets
    
    // Collection view
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView?.delegate = self
            collectionView?.dataSource = self
            collectionView?.register(UINib(nibName: String(describing: ItemPreviewCell.self), bundle: nil), forCellWithReuseIdentifier: "itemCell")
            collectionView?.register(UINib(nibName: String(describing: AlternatePreviewCell.self.self), bundle: nil), forCellWithReuseIdentifier: "alternateCell")
            collectionView?.isPagingEnabled = true
            collectionView?.backgroundColor = .white
            collectionView?.showsHorizontalScrollIndicator = false
            
            let flow = UICollectionViewFlowLayout()
            flow.minimumInteritemSpacing = 0.0
            flow.minimumLineSpacing = 0.0
            flow.scrollDirection = .horizontal
            
            collectionView?.collectionViewLayout = flow
        }
    }
    
    // Data labels
    @IBOutlet weak var offersLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    
    // Page indicators
    @IBOutlet weak var page1Indicator: UIView!
    @IBOutlet weak var page2Indicator: UIView!
    @IBOutlet weak var page3Indicator: UIView!
    @IBOutlet weak var page4Indicator: UIView!

    // User option views
    @IBOutlet weak var shopView: UIView!
    @IBOutlet weak var eventsView: UIView!
    @IBOutlet weak var personalShopperView: UIView!
    @IBOutlet weak var offersView: UIView!
    @IBOutlet weak var loyaltyPointsView: UIView!
    
    // Icons
    @IBOutlet weak var shopIcon: UIImageView!
    @IBOutlet weak var eventsIcon: UIImageView!
    @IBOutlet weak var personalShopperIcon: UIImageView!
    @IBOutlet weak var offersIcon: UIImageView!
    @IBOutlet weak var loyaltyPointsIcon: UIImageView!
}

fileprivate var lastXOffset: CGFloat!

extension HomeViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // If scrolled past to end move back to beginning and visa-versa
        if lastXOffset == nil {
            lastXOffset = scrollView.contentOffset.x
        }
        
        let currentX = scrollView.contentOffset.x
        let currentY = scrollView.contentOffset.y
        
        let pageWidth = scrollView.frame.size.width
        let offset = pageWidth * 4
        
        // scrolled all the way to the left
        if currentX < pageWidth && lastXOffset > currentX {
            lastXOffset = currentX + offset
            scrollView.contentOffset = CGPoint(x: lastXOffset, y: currentY)
        }
        // scrolled all the way to the right
        else if currentX > offset && lastXOffset < currentX {
            lastXOffset = currentX - offset
            scrollView.contentOffset = CGPoint(x: lastXOffset, y: currentY)
        }
        
        
        // Rotate page indicator
        let idx = Int(currentX/pageWidth) + 3
        let mod = idx % 4
        
        _ = indicators.map { $0.backgroundColor = .white }
        indicators[mod].backgroundColor = AppDelegate.Static.tint
        
    }
}

extension HomeViewController: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // return 2 more than the total
        return 6
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // rotate index
        let idx = indexPath.item + 3
        
        // use modulous to determine current page
        let mod = idx % 4
        
        // dequeue appropriate cell type
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mod < 2 ? "itemCell" : "alternateCell", for: indexPath)
        
        // configure cell
        switch mod {
        case 0:
            (cell as! ItemPreviewCell).configure(UIImage(named: "red-shoes")!)
        case 1:
            (cell as! ItemPreviewCell).configure(UIImage(named: "black-heels")!)
        case 2:
            let style = AlternatePreviewCellStyle(
                image: UIImage(named: "runway-models")!,
                primaryText: "Fashion Show",
                secondaryText: "December 1st 2016",
                actionText: "Get Tickets"
            )
            (cell as! AlternatePreviewCell).configure(withStyle: style)
        case 3:
            let style = AlternatePreviewCellStyle(
                image: UIImage(named: "girl-fashion")!,
                primaryText: "Personal Shopper",
                secondaryText: nil,
                actionText: "Book Now"
            )
            (cell as! AlternatePreviewCell).configure(withStyle: style)
        default : fatalError("Impossible case!")
        }
        
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegate {
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
}
