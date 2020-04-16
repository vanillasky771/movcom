//
//  MovieDetailView.swift
//  movcom
//
//  Created by Ivan on 15/04/20.
//  Copyright © 2020 ivan. All rights reserved.
//

import UIKit
import Alamofire
import WebKit
import SDWebImage

class MovieDetailView: UIViewController {
    
    //MARK: -Var & Outlet
    @IBOutlet weak var movieTitle: UILabel!
    var movieTitles  : String!
    var movieID     : Int!
    var voteAverage : Double!
    var popularity  : Double!
    var backdropPth : String!
    var posterPth   : String!
    var overviews   : String!
    var releaseDate : String!
    var items       : [TResult] = []
    @IBOutlet weak var backdropImage: UIImageView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var voteAverages: UILabel!
    @IBOutlet weak var overviewText: UITextView!
    @IBOutlet weak var popularityText: UILabel!
    @IBOutlet weak var releaseDates: UILabel!
    @IBOutlet weak var movieButton: UIButton!
    @IBOutlet weak var reviewButton: UIButton!
    
    func initialize(){
        fetchTrailer(movID: movieID)
        movieTitle.text = movieTitles
        voteAverages.text   = String(voteAverage)
        popularityText.text = String(popularity)+" Watchers"
        releaseDates.text   = releaseDate
        overviewText.text   = overviews
        if (backdropPth != nil){
            backdropImage.sd_setImage(with: URL(string: imageHost+backdropPth))
        }else{
            backdropImage.sd_setImage(with: URL(string: imageHost+"/5BwqwxMEjeFtdknRV792Svo0K1v.jpg"))
        }
        if(posterPth != nil){
            posterImage.sd_setImage(with: URL(string: imageHost+posterPth))
        }else{
            posterImage.sd_setImage(with: URL(string: imageHost+"/xBHvZcjRiWyobQ9kxBhO6B2dtRI.jpg"))
        }
        overviewText.backgroundColor = UIColor.clear
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    @IBAction func playTrailerButton(_ sender: Any) {
        performSegue(withIdentifier: "playTrailer", sender: self)
    }
    
    @IBAction func seeReview(_ sender: Any) {
        performSegue(withIdentifier: "reviewView", sender: self)
    }
}
extension MovieDetailView{
    func fetchTrailer(movID: Int){
        let url = host+"movie/\(movID)/videos?api_key=765f90b887428e11c9c3f8439cd80f8b&language=en-US"
        AF.request(url)
        .validate()
        .responseDecodable(of: Trailer.self) { (data) in
          guard let films = data.value else { print(data.error!)
            return }
            self.items = films.results
            if self.items.count == 0{
               self.movieButton.isHidden = true
            }
            
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let _ = sender as? UIButton,
        let _ = movieID{
            if (segue.identifier == "playTrailer"){
                let vc = segue.destination as! TrailerView
                vc.videoKey = items[0].key.isEmpty ? items[0].key : items[0].key
            }else{
                let vc = segue.destination as! ReviewView
                vc.movIDs = self.movieID
            }
        }
        
    }
}
