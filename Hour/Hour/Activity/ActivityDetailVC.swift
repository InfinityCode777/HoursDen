//
//  ActivityDetailVC.swift
//  Hour
//
//  Created by Jing Wang on 10/14/19.
//  Copyright © 2019 Jackalope. All rights reserved.
//

import UIKit

class ActivityDetailVC: ActivityBaseVC {
    
    @IBOutlet weak var activityTitleLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var detailScrollView: UIScrollView!
    @IBOutlet weak var canvasView: UIView!
    
    
        //TOTO we need to fnd way to link model with view/cell
    public var activity: ActivityModel?
    { didSet {
//        setupUI()
        print("1")
        }}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        closeBtn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.65), for: .normal)
        print("2")
        


    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("3")
    }
    
    @IBAction func closeBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func setupUI() {
        canvasView.backgroundColor = activity?.bgColor
        activityTitleLabel.text = activity?.name
    }
    
}
