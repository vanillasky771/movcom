//
//  ReviewView.swift
//  movcom
//
//  Created by Ivan on 15/04/20.
//  Copyright © 2020 ivan. All rights reserved.
//

import UIKit
import Alamofire
let useAutosizingCells = true

class ReviewView: UITableViewController {

    //MARK: - Declaration & Variable
    var currentPage = 1
    var numPages    = 0
    var reviews     = [ResultReviews]()
    var movIDs       = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if useAutosizingCells && tableView.responds(to: #selector(getter: UIView.layoutMargins)){
            tableView.estimatedRowHeight = 100
            tableView.rowHeight = UITableView.automaticDimension
        }
        tableView.separatorColor = .black
        tableView.infiniteScrollIndicatorView = CustomInfiniteIndicator(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        tableView.infiniteScrollIndicatorMargin = 30
        tableView.infiniteScrollTriggerOffset = 500
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.addInfiniteScroll { [weak self] (tableView) -> Void in
            self?.fetchReviews {
                tableView.finishInfiniteScroll()
            }
        }
        tableView.beginInfiniteScroll(true)
    }
    
    func fetchReviews(_ completionHandler: (() -> Void)?){
        fetchData{ (dataResult) in
            defer { completionHandler?() }
            
            switch dataResult {
            case .ok(let response):
                let reviewCount = self.reviews.count
                let (start, end) = (reviewCount, response.results.count + reviewCount)
                let indexPaths = (start..<end).map {return IndexPath(row: $0, section: 0)}
                
                self.reviews.append(contentsOf: response.results)
                self.numPages = (response.page) == 0 ? 0 : response.page!
                self.currentPage += 1
                
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: indexPaths, with: .automatic)
                self.tableView.endUpdates()
                
            case .error(let error):
                self.showAlertWithError(error)
            }
        }
    }
    
    func showAlertWithError(_ error: Error) {
        let alert = UIAlertController(title: NSLocalizedString("tableView.errorAlert.title", comment: ""),
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("tableView.errorAlert.dismiss", comment: ""),
                                      style: .cancel,
                                      handler: nil))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("tableView.errorAlert.retry", comment: ""),
                                      style: .default,
                                      handler: { _ in self.fetchReviews(nil) }))
        
        present(alert, animated: true, completion: nil)
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let review = reviews[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewTable", for: indexPath) as! ReviewCell
        cell.backgroundColor = .clear
        cell.layer.borderColor = UIColor.black.cgColor
        cell.authorName.text = review.author
        cell.reviewContent.text = review.content
        
        if useAutosizingCells && tableView.responds(to: #selector(getter:
            UIView.layoutMargins)){
            cell.authorName?.numberOfLines = 0
            cell.reviewContent?.numberOfLines = 0
        }
        return cell
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        if reviews.count != 0{
            self.tableView.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
            
        }else{
            tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
            self.tableView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "noData"))
        }
        return 1
    }
}

//MARK: -Fetching Data
extension ReviewView {
    typealias FetchResult = Results<Reviews, FetchError>
    
    func makeRequest(numHits: Int, page: Int) -> URLRequest {
        let url = URL(string:host+"movie/\(numHits)/reviews?api_key=765f90b887428e11c9c3f8439cd80f8b&language=en-US&page=\(page)")!
        return URLRequest(url: url)
    }
    
    func fetchData(handler: @escaping ((FetchResult) -> Void)){
        let request = makeRequest(numHits: movIDs, page: currentPage)
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            (data, _, networkError) -> Void in
            DispatchQueue.main.async {
                handler(handleFetchResponse(data: data!, networkError: networkError))
            }
        })
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            task.resume()
        })
        
    }
}
