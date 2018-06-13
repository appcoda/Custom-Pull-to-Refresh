//
//  ViewController.swift
//  PullRefresh
//
//  Created by Gabriel Theodoropoulos on 6/6/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tblDemo: UITableView!
    
    var dataArray: Array<String> = ["One", "Two", "Three", "Four", "Five"]
    
    var refreshControl: UIRefreshControl!
    
    var customView: UIView!
    
    var labelsArray: Array<UILabel> = []
    
    var isAnimating = false
    
    var currentColorIndex = 0
    
    var currentLabelIndex = 0
    
    var timer: Timer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tblDemo.delegate = self
        tblDemo.dataSource = self
        
        refreshControl = UIRefreshControl()
        
        refreshControl.backgroundColor = UIColor.clear
        refreshControl.tintColor = UIColor.clear
        tblDemo.addSubview(refreshControl)
        
        loadCustomRefreshContents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: UITableview method implementation
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "idCell", for: indexPath as IndexPath)
        
        cell.textLabel!.text = dataArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    // MARK: UIScrollView delegate method implementation
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if refreshControl.isRefreshing {
            if !isAnimating {
                doSomething()
                animateRefreshStep1()
            }
        }
    }
    
    
    // MARK: Custom function implementation
    
    func loadCustomRefreshContents() {
        let refreshContents = Bundle.main.loadNibNamed("RefreshContents", owner: self, options: nil)
        
        customView = refreshContents![0] as! UIView
        customView.frame = refreshControl.bounds
        
        for i in 0..<customView.subviews.count {
            labelsArray.append(customView.viewWithTag(i + 1) as! UILabel)
        }
        
        refreshControl.addSubview(customView)
    }
    
    
    func animateRefreshStep1() {
        isAnimating = true
        
        
        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveLinear, animations: { () -> Void in
            self.labelsArray[self.currentLabelIndex].transform = CGAffineTransform(rotationAngle: CGFloat(Float.pi/4))
            self.labelsArray[self.currentLabelIndex].textColor = self.getNextColor()
            
            }, completion: { (finished) -> Void in
                
                UIView.animate(withDuration: 0.05, delay: 0.0, options: .curveLinear, animations: { () -> Void in
                    self.labelsArray[self.currentLabelIndex].transform = CGAffineTransform.identity
                    self.labelsArray[self.currentLabelIndex].textColor = UIColor.black
                    
                    }, completion: { (finished) -> Void in
                        self.currentLabelIndex += 1
                        
                        if self.currentLabelIndex < self.labelsArray.count {
                            self.animateRefreshStep1()
                        }
                        else {
                            self.animateRefreshStep2()
                        }
                })
        })
    }
    
    
    func animateRefreshStep2() {
        UIView.animate(withDuration: 0.35, delay: 0.0, options: .curveLinear, animations: { () -> Void in
            self.labelsArray[0].transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.labelsArray[1].transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.labelsArray[2].transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.labelsArray[3].transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.labelsArray[4].transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.labelsArray[5].transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.labelsArray[6].transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            
            }, completion: { (finished) -> Void in
                UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveLinear, animations: { () -> Void in
                    self.labelsArray[0].transform = CGAffineTransform.identity
                    self.labelsArray[1].transform = CGAffineTransform.identity
                    self.labelsArray[2].transform = CGAffineTransform.identity
                    self.labelsArray[3].transform = CGAffineTransform.identity
                    self.labelsArray[4].transform = CGAffineTransform.identity
                    self.labelsArray[5].transform = CGAffineTransform.identity
                    self.labelsArray[6].transform = CGAffineTransform.identity
                    
                    }, completion: { (finished) -> Void in
                        if self.refreshControl.isRefreshing {
                            self.currentLabelIndex = 0
                            self.animateRefreshStep1()
                        }
                        else {
                            self.isAnimating = false
                            self.currentLabelIndex = 0
                            for i in 0..<self.labelsArray.count {
                                self.labelsArray[i].textColor = UIColor.black
                                self.labelsArray[i].transform = CGAffineTransform.identity
                            }
                        }
                })
        })
    }
    
    
    func getNextColor() -> UIColor {
        var colorsArray: Array<UIColor> = [UIColor.magenta, UIColor.brown, UIColor.yellow, UIColor.red, UIColor.green, UIColor.blue, UIColor.orange]
        
        if currentColorIndex == colorsArray.count {
            currentColorIndex = 0
        }
        
        let returnColor = colorsArray[currentColorIndex]
        currentColorIndex += 1
        
        return returnColor
    }
    
    
    func doSomething() {
        timer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(endOfWork), userInfo: nil, repeats: true)
    }
    
    
    @objc func endOfWork() {
        refreshControl.endRefreshing()
        
        timer.invalidate()
        timer = nil
    }
    
}

