//
//  MovieView.swift
//  movcom
//
//  Created by Ivan on 14/04/20.
//  Copyright © 2020 ivan. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class MovieView: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK: -Outlet & Var
    
    @IBOutlet weak var loadingActivity: UIActivityIndicatorView!
    @IBOutlet weak var movieCollection: UICollectionView!
    @IBOutlet weak var movieGenre: UILabel!
    var genreID     : Int!
    var genreName   : String!
    var items       = [Result]()
    var pageCount   = 1
    
    //MARK: - Initialization
    func initialize(){
        movieCollection.backgroundColor = UIColor.clear
        movieGenre.text = genreName
//        fetchMovie(id: genreID!,page: pageCount)
        movieCollection.dataSource = self
        movieCollection.delegate = self
        movieCollection.infiniteScrollIndicatorView = CustomInfiniteIndicator(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
         movieCollection.infiniteScrollIndicatorMargin = 40
         
         movieCollection.addInfiniteScroll {[weak self] (scrollView) -> Void in
             self?.performFetch({
                
                 scrollView.finishInfiniteScroll()
                self?.loadingActivity.stopAnimating()
                self?.loadingActivity.isHidden = true
             })
         }
        movieCollection.beginInfiniteScroll(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadingActivity.startAnimating()
        initialize()
        
    }
}

extension MovieView{
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        debugPrint("invlaidate")
    }
    //MARK: -Fetching Data from API with Param
    func performFetch(_ completionHandler:(() -> Void)?){
        fetchMovie { (result) in
            switch result {
            case .ok(let response):
                let newItems = response.results
                
                let dataCount = self.items.count
                let (start, end) = (dataCount, newItems.count + dataCount)
                let indexPath = (start..<end).map { return IndexPath(row: $0, section: 0)}
                
                self.items.append(contentsOf: newItems)
                self.movieCollection.performBatchUpdates({ () -> Void in
                    self.movieCollection.insertItems(at: indexPath)}, completion: { (finished) -> Void in
                        completionHandler?()
                        self.pageCount = self.pageCount + 1
                })
            case .error(let error):
                print(error)
            }
        }
    }
    
    typealias FetchResult = Results<Movie, FetchError>
    
    func makeReq(id: Int, page: Int) -> URLRequest{
        let url = URL(string: host+"discover/movie?language=en-US&include_adult=false&page=\(page)&api_key=765f90b887428e11c9c3f8439cd80f8b&include_video=true&with_original_language=en&with_genres=\(id)")!
        return URLRequest(url: url)
    }
    func fetchMovie(handler: @escaping ((FetchResult)-> Void)){
        let request = makeReq(id: genreID!, page: pageCount)
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            (data, _, Err) -> Void in
            DispatchQueue.main.async {
                handler(handleFetchResponse(data: data, networkError: Err))
            }
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            task.resume()
        })
    }
    //MARK: - CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieCell
        let imgPath = (items[indexPath.row].posterPath ?? "").isEmpty ? "/7W0G3YECgDAfnuiHG91r8WqgIOe.jpg" : items[indexPath.row].posterPath!
        let urls = imageHost+imgPath
        cardImageView(image: cell.moviePoster, radius: 10)
        cell.moviePoster.sd_setImage(with: URL(string: urls))
        cell.movieTitle.text = items[indexPath.row].title

        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "movieDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UICollectionViewCell,
            let indexPath = movieCollection.indexPath(for: cell){
            if(segue.identifier == "movieDetail"){
                let vc = segue.destination as! MovieDetailView
                vc.movieTitles      = items[indexPath.row].title
                vc.movieID          = items[indexPath.row].id
                vc.voteAverage      = items[indexPath.row].voteAverage
                vc.popularity       = items[indexPath.row].popularity
                vc.backdropPth      = items[indexPath.row].backdropPath
                vc.posterPth        = items[indexPath.row].posterPath
                vc.overviews        = items[indexPath.row].overview
                vc.releaseDate      = items[indexPath.row].releaseDate
            }
        }
    }
    
    func cardImageView(image: UIImageView, radius: CGFloat){
        image.layer.cornerRadius = radius
    }
}

extension MovieView: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = collectionView.bounds.width;
        let itemWidth = collectionWidth / 2 - 7 ;
        let itemHeight = collectionWidth - 49 ;
        return CGSize(width: itemWidth, height: itemHeight);
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}
