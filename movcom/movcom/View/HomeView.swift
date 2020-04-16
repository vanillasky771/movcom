//
//  ViewController.swift
//  movcom
//
//  Created by Ivan on 14/04/20.
//  Copyright © 2020 ivan. All rights reserved.
//

import UIKit
import Alamofire
var host = "https://api.themoviedb.org/3/"
var imageHost = "https://image.tmdb.org/t/p/w300"
class HomeView: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate  {
    

    //MARK: - Outlets & Var
    @IBOutlet weak var GenreCollectionView: UICollectionView!
    var items: [GenreElement] = []
    var genreImage = ["Action","Adventure","Animation","Comedy","Crime","Documentary","Adventure","Comedy","Animation","Documentary","Horror", "Comedy","Mistery", "Comedy", "Action", "Crime", "Horror", "Adventure", "Crime"]
    
    //MARK: -Initialize
    func initialize(){
        GenreCollectionView.backgroundColor = UIColor.clear
        fetchGenre()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
}

extension HomeView{
    //MARK: -Fetching Genre data From API
    func fetchGenre(){        AF.request(host+"genre/movie/list?api_key=765f90b887428e11c9c3f8439cd80f8b&language=en-US")
        .validate()
        .responseDecodable(of: Genre.self) { (response) in
          guard let films = response.value else { return }
            self.items = films.genres
            self.GenreCollectionView.reloadData()
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "genreCell", for: indexPath) as! GenreCell
        cardView(view: cell.genreView, radius: 10)
        UIGraphicsBeginImageContext(cell.genreView.frame.size)
        var image = UIImage(named: genreImage[indexPath.row])
        image?.draw(in: cell.genreView.bounds)
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        cell.genreView.backgroundColor = UIColor(patternImage: image!)
        
        cell.genreName.text = items[indexPath.row].name
        cell.overlayview.backgroundColor = UIColor(red:0.26, green:0.26, blue:0.26, alpha:0.70)
        cardView(view: cell.overlayview, radius: 10)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "moviePage", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell  = sender as? UICollectionViewCell,
            let indexPath = GenreCollectionView.indexPath(for: cell){
            if (segue.identifier == "moviePage"){
                let vc = segue.destination as! MovieView
                vc.genreName = items[indexPath.row].name
                vc.genreID = items[indexPath.row].id
            }
        }
        
    }
    func cardView(view: UIView, radius: CGFloat){
        view.layer.cornerRadius = radius
    }
}

