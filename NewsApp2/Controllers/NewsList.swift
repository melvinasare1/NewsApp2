//
//  NewsList.swift
//  NewsApp2
//
//  Created by Melvin Asare  on 09/01/2020.
//  Copyright © 2020 Melvin Asare . All rights reserved.

import UIKit

class NewsList:  UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tableView:  UITableView = {
        let tableView = UITableView()
        
        return tableView
    }()
    
    let cellID = "tableViewCell"
    
    
    
    private var articleListVM: ArticleListViewModel!
    
    let urlAddres: String = "http://newsapi.org/v2/everything?q=bitcoin&apiKey=6864313e2cfe4b9bb6999684302c4902"
    let url: URL? = nil
    
    
    
    
    
    
    
    
    
//    func loadUrl() {
//        if let url = URL(string: urlAddres) {
//            do {
//                let contents = try String(contentsOf: url)
//                print(contents)
//                setup()
//            }
//            catch {
//                print(error.localizedDescription)
//            }
//        } else {
//            print("error")
//        }
//    }
//
    
    func setup() {
        
    let url = URL(string: "http://newsapi.org/v2/everything?q=bitcoin&apiKey=6864313e2cfe4b9bb6999684302c4902")!
        
        
        
        WebServices().getArticles(url: url) { articles in
            if let articles = articles {
                self.articleListVM = ArticleListViewModel(articles: articles)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func positionConstraints() {
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        var doneReading = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            print("Delete")
            self.articleListVM.articles.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        return [doneReading]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.articleListVM == nil ? 0 : self.articleListVM.numberOfSection
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleListVM.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! NewsListCell
        
        
        let articleVM = self.articleListVM.articlesAtIndex(indexPath.row)
        
        //      let articleVmImage = articleVM.urlToString
        cell.newsTitle.text = articleVM.title
        cell.newsDescription.text = articleVM.description
        articleVM.urlToString.stringToImage { (image) in
            
            DispatchQueue.main.async {
                cell.newsUrlToImage.image = image
            }
        }
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 360
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = Recommended()
        present(vc, animated: true, completion: nil)
    }
    
    override func viewWillLayoutSubviews() {
        view.addSubview(tableView)
    }
    
    func tableViewConfig() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    
    func configureUI() {
        navigationItem.title = "Articles"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewWillLayoutSubviews()
        tableViewConfig()
        configureUI()
  //      loadUrl()
        setup()
        view.backgroundColor = .white
        tableView.register(NewsListCell.self, forCellReuseIdentifier: cellID)
    }
}

extension NewsList : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}

extension String {
    func stringToImage(_ handler: @escaping ((UIImage?)->())) {
        if let url = URL(string: self) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    let image = UIImage(data: data)
                    handler(image)
                }
            }.resume()
        }
    }
}
