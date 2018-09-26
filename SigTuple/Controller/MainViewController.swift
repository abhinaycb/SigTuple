//
//  ViewController.swift
//  SigTuple
//
//  Created by Coffeebeans on 25/09/18.
//  Copyright © 2018 Coffeebeans. All rights reserved.
//

import UIKit
import Toast_Swift

class MainViewController: UIViewController {

    @IBOutlet weak var organizationField: UITextField!
    @IBOutlet weak var repoField: UITextField!
    @IBOutlet weak var openIssuesTableView: UITableView!
    @IBOutlet weak var closedIssuesTableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var openIssuesHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var closedIssueHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var goToClosedButton: UIButton!
    @IBOutlet weak var rightDistanceOfHiddenButton: NSLayoutConstraint!
    
    private let viewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.isScrollEnabled = true
        registerCellForTableViews()
        activityView.stopAnimating()
        organizationField.text = "prestodb"
        repoField.text = "presto"
        openIssuesHeightConstraint.constant = 0.0
        closedIssueHeightConstraint.constant = 0.0
        self.view.layoutSubviews()
        self.view.layoutIfNeeded()
        self.openIssuesTableView.isScrollEnabled = false
        closedIssuesTableView.isScrollEnabled = false
        goToClosedButton.layer.cornerRadius = 5.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width, height: 120.0)
        self.goToClosedButton.alpha = 0.0
    }
    
    
    func registerCellForTableViews() {
        openIssuesTableView.register(UINib(nibName: "IssueTableViewCell", bundle: nil).self, forCellReuseIdentifier: cellIdentifier)
        closedIssuesTableView.register(UINib(nibName: "IssueTableViewCell", bundle: nil).self, forCellReuseIdentifier: cellIdentifier)
        openIssuesTableView.tag = 0
        closedIssuesTableView.tag = 1
        openIssuesTableView.estimatedRowHeight = 180.0
        closedIssuesTableView.estimatedRowHeight = 180.0
        closedIssuesTableView.tableFooterView = UIView()
        openIssuesTableView.tableFooterView = UIView()
        openIssuesTableView.sectionFooterHeight = 0.0
        closedIssuesTableView.sectionFooterHeight = 0.0
    }

    func showError(_ errorMessage:String) {
        // create a new style
        var style = ToastStyle()
        style.messageColor = .red
         DispatchQueue.main.async {
            self.view.makeToast(errorMessage, duration: 2.0, position: .center, style: style)
        }
    }
    
    
    @IBAction func fetchIssues(_ sender: Any) {
        view.endEditing(true)
        activityView.startAnimating()
        if(organizationField.text != "" && repoField.text != "") {
            NetworkLayer.sharedInstance.getOpenOrClosedIssues(orgName: organizationField.text!, repoName: repoField.text!) { [weak self](openIssues,closedIssues) in
                if(openIssues != nil ) {
                    self?.viewModel.dataSourceForOpenIssues = openIssues
                }else{
                    self?.viewModel.dataSourceForOpenIssues = []
                    self?.showError("Data Not Found")
                }
                if(closedIssues != nil) {
                    self?.viewModel.dataSourceForClosedIssues = closedIssues
                }else {
                    self?.viewModel.dataSourceForClosedIssues = []
                    self?.showError("error parsing closedIssues")
                }
                self?.updateData()
            }
        }else{
            self.viewModel.dataSourceForOpenIssues = []
            self.viewModel.dataSourceForClosedIssues = []
            self.updateData()
            showError("please enter valid org name or repo name")
            print("please enter valid org name or repo name")
        }
        
    }
    
    func updateData() {
        DispatchQueue.main.async {
            self.activityView.stopAnimating()
            self.openIssuesTableView.reloadData()
            self.closedIssuesTableView.reloadData()
            
            self.openIssuesTableView.beginUpdates()
            self.openIssuesHeightConstraint.constant = self.openIssuesTableView.contentSize.height
            self.openIssuesTableView.endUpdates()
            self.closedIssuesTableView.beginUpdates()
            self.closedIssueHeightConstraint.constant = self.closedIssuesTableView.contentSize.height + 100.0
            self.closedIssuesTableView.endUpdates()
            self.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width, height: self.openIssuesTableView.contentSize.height + self.closedIssuesTableView.contentSize.height + 240.0)
        }
    }
    
    @IBAction func hiddenButtonClicked(_ sender: Any) {
        if let senderButton = sender as? UIButton {
            if(senderButton.titleLabel!.text == "Go To Closed Issues") {
                self.scrollView.scrollRectToVisible(CGRect(x: 0.0, y: (180.0 * CGFloat((self.viewModel.dataSourceForOpenIssues?.count)!)) + 100.0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height), animated: true)
            }else{
               self.scrollView.scrollRectToVisible(CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height), animated: true)
            }
        }
    }
    
}

extension MainViewController:UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView.tag == 0) {
            return self.viewModel.dataSourceForOpenIssues?.count ?? 0
        }else if(tableView.tag == 1){
            return self.viewModel.dataSourceForClosedIssues?.count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? IssueTableViewCell
        if(tableView.tag == 0){
            cell?.configureCell(self.viewModel.dataSourceForOpenIssues?[indexPath.row])
        }else if(tableView.tag == 1){
            cell?.configureCell(self.viewModel.dataSourceForClosedIssues?[indexPath.row])
        }
       
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if(goToClosedButton.alpha == 0.0) {
            if(scrollView.contentOffset.y >= (CGFloat((self.viewModel.dataSourceForOpenIssues?.count)!) * 180.0 )) {
                self.goToClosedButton.titleLabel!.text = "Go To Open Issues"
                self.goToClosedButton.backgroundColor = AppColors.greenColor
            }else{
                self.goToClosedButton.titleLabel!.text = "Go To Closed Issues"
                self.goToClosedButton.backgroundColor = AppColors.redColor
            }
            animateCloseButton(true)
        }
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        animateCloseButton(false)
    }

    func animateCloseButton(_ flag:Bool) {
        print("called with flag value \(flag)")
        if(flag){
            UIView.animate(withDuration: 4.0, delay: 0.0, options: .allowUserInteraction, animations: {
                DispatchQueue.main.async {
                    self.goToClosedButton.alpha = 1.0
                }
            })
        }else{
            UIView.animate(withDuration: 4.0,delay: 0.0,options: .allowUserInteraction, animations: {
                DispatchQueue.main.async {
                    self.goToClosedButton.alpha = 0.0
                }
            })
        }
    }
}
