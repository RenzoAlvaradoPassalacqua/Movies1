//
//  SearchViewController.swift
//  AppleCoding OAuth
//
//  Created by Adolfo Vera Blasco on 28/5/18.
//  Copyright © 2018 desappstre {eStudio}. All rights reserved.
//

import UIKit
import Foundation
import SafariServices

import CoreTraktTV

internal class SearchViewController: UIViewController,UICollectionViewDelegateFlowLayout
{
    ///
    @IBOutlet private weak var collectionViewShows: UICollectionView!

    ///
    private var movies: [Movie]?
    ///
    private var paginationDetails: Pagination?
    private var paginationFilter : [PaginationFilter] = [PaginationFilter]()
    private let refreshControl = UIRefreshControl()
    private var goToNextpage : Bool = false
    
    var footerView:CustomFooterView?
    var items = [Int]()
    var isLoading:Bool = false
    var currentPage = 1
    var pageCount = 0
    let footerViewReuseIdentifier = "RefreshFooterView"
   
    // MARK: - Life Cycle
    //

    /**

    */
    override internal func viewDidLoad()
    {
        super.viewDidLoad()

        self.movies = [Movie]()
        self.prepareCollectionView()
        print ("viewDidLoad currentPage", self.currentPage)
        
        self.loadPopularMovies( numPage : self.pageCount, currentPage: self.currentPage)
    }
    
    /**
     
     */
    override internal func viewWillAppear(_ animated: Bool) -> Void
    {
        super.viewWillAppear(animated)
        
        self.applyTheme()
        self.localizeText()
    }
    
    //
    // MARK: - Prepare UI
    //
    
    /**
     
     */
    private func prepareCollectionView() -> Void
    {
        self.collectionViewShows.delegate = self
        self.collectionViewShows.dataSource = self
        self.collectionViewShows.prefetchDataSource = self
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            self.collectionViewShows.refreshControl = refreshControl
        } else {
            self.collectionViewShows.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(loadMorePopularMovies(_:)), for: .valueChanged)
        
        self.collectionViewShows.register(UINib(nibName: "CustomFooterView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerViewReuseIdentifier)
        //
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if isLoading {
            return CGSize.zero
        }
        return CGSize(width: collectionView.bounds.size.width, height: 55)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerViewReuseIdentifier, for: indexPath) as! CustomFooterView
            self.footerView = aFooterView
            self.footerView?.backgroundColor = UIColor.clear
            return aFooterView
        } else {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerViewReuseIdentifier, for: indexPath)
            return headerView
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.footerView?.prepareInitialAnimation()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.footerView?.stopAnimate()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let threshold   = 100.0 ;
        let contentOffset = scrollView.contentOffset.y;
        let contentHeight = scrollView.contentSize.height;
        let diffHeight = contentHeight - contentOffset;
        let frameHeight = scrollView.bounds.size.height;
        var triggerThreshold  = Float((diffHeight - frameHeight))/Float(threshold);
        triggerThreshold   =  min(triggerThreshold, 0.0)
        let pullRatio  = min(abs(triggerThreshold),1.0);
        self.footerView?.setTransform(inTransform: CGAffineTransform.identity, scaleFactor: CGFloat(pullRatio))
        if pullRatio >= 1 {
            self.footerView?.animateFinal()
        }
        print("pullRation:\(pullRatio)")
    }
    
    //compute the offset and call the load method
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y;
        let contentHeight = scrollView.contentSize.height;
        let diffHeight = contentHeight - contentOffset;
        let frameHeight = scrollView.bounds.size.height;
        let pullHeight  = abs(diffHeight - frameHeight);
        print("pullHeight:\(pullHeight)");
        if pullHeight == 0.0
        {
            if (self.footerView?.isAnimatingFinal)! {
                print("load more trigger")
                self.isLoading = true
                self.footerView?.startAnimate()
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (timer:Timer) in
                    for i:Int in self.items.count + 1...self.items.count + 25 {
                        self.items.append(i)
                    }
                    self.collectionViewShows.reloadData()
                    self.isLoading = false
                })
            }
        }
    }
    
    @objc private func loadMorePopularMovies(_ sender: Any) {
        print ("loadMorePopularMovies")
        self.goToNextpage = true
        // Fetch Weather Data
        self.paginationFilter = (self.paginationDetails?.nextPage())!
        
        self.pageCount = (self.paginationDetails?.pageCount)!
        self.currentPage = (self.paginationDetails?.currentPage)!
        print ("currentPage loadMorePopularMovies", self.currentPage)
        self.loadPopularMovies( numPage : self.pageCount, currentPage: self.currentPage)
        self.currentPage = self.currentPage + 1
    }
    
    
    /**
     
     */
    private func applyTheme() -> Void
    {
        self.view.backgroundColor = Theme.current.backgroundColor
        self.collectionViewShows.backgroundColor = Theme.current.backgroundColor
    }
    
    /**
     
     */
    private func localizeText() -> Void
    {
        self.title = NSLocalizedString("SEARCH_TITLE", comment: "")
    }

    //
    // MARK: - Data
    //

    private func loaTrendingdMovies() -> Void
    {
        
        TraktTVClient.shared.trendingMovies() { (trendyMovies: [TrendyMovie]?, pagination: Pagination?, error: TraktError?) -> Void in
            guard let trendyMovies = trendyMovies else
            {
                return
            }
            
            let movies = trendyMovies.map({ $0.movie })
            
            self.paginationDetails = pagination
            self.movies?.append(contentsOf: movies)
            
            DispatchQueue.main.async
                {
                    self.collectionViewShows.reloadData()
                    
            }
        }
    }
    private func loadPopularMovies(numPage : Int, currentPage: Int) -> Void
    {
        var nextPage=0
        if (self.goToNextpage){
            if (numPage <= currentPage){
                nextPage = currentPage + 1
            }else{
                nextPage = currentPage
            }
            
            TraktTVClient.shared.popularMovies( nextPage:nextPage ) { (popularMovies: [Movie]?, pagination: Pagination?, error: TraktError?) -> Void in
                guard let popularMovies = popularMovies else
                {
                    return
                }
                
                self.paginationDetails = pagination
                
                self.movies? = (popularMovies)
                
                DispatchQueue.main.async
                    {
                        self.collectionViewShows.reloadData()
                        self.refreshControl.endRefreshing()
                        self.goToNextpage = false
                }
            }
        }
        else{
            TraktTVClient.shared.popularMovies( ) { (popularMovies: [Movie]?, pagination: Pagination?, error: TraktError?) -> Void in
                guard let popularMovies = popularMovies else
                {
                    return
                }
                
                self.paginationDetails = pagination
                
                self.movies? = (popularMovies)
                
                DispatchQueue.main.async
                    {
                        self.collectionViewShows.reloadData()
                        self.refreshControl.endRefreshing()
                }
            }
        }
    }
        
}


//
// MARK: - UICollectionViewDataSource Protocol
//
public extension UICollectionView {
    
    public func beginRefreshing() {
        // Make sure that a refresh control to be shown was actually set on the view
        // controller and the it is not already animating. Otherwise there's nothing
        // to refresh.
        guard let refreshControl = refreshControl, !refreshControl.isRefreshing else {
            return
        }
        
        // Start the refresh animation
        refreshControl.beginRefreshing()
        
        // Make the refresh control send action to all targets as if a user executed
        // a pull to refresh manually
        refreshControl.sendActions(for: .valueChanged)
        
        // Apply some offset so that the refresh control can actually be seen
        // let contentOffset = CGPoint(x: 0, y: -refreshControl.frame.height)
        //setContentOffset(contentOffset, animated: true)
    }
    
    public func endRefreshing() {
        refreshControl?.endRefreshing()
    }
}
extension SearchViewController: UICollectionViewDataSource
{
    /**
     
     */
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    /**
     
     */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        guard let movies = self.movies else
        {
            return 0
        }

        return movies.count
    }
    
    /**
     
     */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        guard let movies = self.movies, !movies.isEmpty else
        {
            return UICollectionViewCell()
        }

        guard let showCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShowCell", for: indexPath) as? ShowCell else
        {
            fatalError("Unable to dequeue a TaskCell")
        }

        showCell.showInformation = movies[indexPath.item]
        showCell.delegate = self
        
        return showCell
    }
}

//
// MARK: - UICollectionViewDelegate Protocol
//

extension SearchViewController: UICollectionViewDelegate
{
    /**
     
     */
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) -> Void
    {
        cell.transform = CGAffineTransform(scaleX: 0.90, y: 0.90)
        cell.alpha = 0.85
        
        let animator = UIViewPropertyAnimator(duration: 0.65, curve: .easeOut)
        
        animator.addAnimations()
        {
            cell.transform = CGAffineTransform.identity
            cell.alpha = 1.0
        }
        
        animator.startAnimation()
    }
}

//
// MARK: - UICollectionViewDataSourcePrefetching Protocol
//

extension SearchViewController: UICollectionViewDataSourcePrefetching
{
    /**
     
     */
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) -> Void
    {
        print("prefetch...")
    }
}

//
// MARK: - ShowCellDelegate Protocol
//

extension SearchViewController: ShowCellDelegate
{
    /**

    */
    func showCell(_ cell: ShowCell, didSelectShow trackID: Int) -> Void 
    {
        /* guard let movie = self.movies?.filter({ $0.identifiers.trakt == trackID }).first else
        {
            return
        }
         
        TraktTVClient.shared.appendToWatchlist(movie, handler: { (validOperation: Bool, error: TraktError?) -> Void in
            if validOperation
            {
                DispatchQueue.main.async
                {
                    cell.toogleButton(toStatus: ShowCell.Status.added)
                }
            }
            else if let error = error
            {
                if case .unauthorized = error
                {
                    // No estamos autorizados a acceder a los datos del usuarios
                    // Vamos a pedirle que nos autorize 
                    if let oauthURL = TraktTVClient.shared.authorizationURL()
                    {
                        let safariController = SFSafariViewController(url: oauthURL)
                        
                        DispatchQueue.main.async
                        {
                            self.present(safariController, animated: true, completion: nil)
                        }
                    }
                }
                else
                {
                    DispatchQueue.main.async
                    {
                        cell.toogleButton(toStatus: ShowCell.Status.error)
                    }
                }
            }
        })
 */
    }
}



