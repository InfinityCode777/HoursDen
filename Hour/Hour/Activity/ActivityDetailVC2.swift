//
//  ActivityDetailVC2.swift
//  Hour
//
//  Created by Jing Wang on 11/11/19.
//  Copyright © 2019 Jackalope. All rights reserved.
//

import UIKit

class ActivityDetailVC2: ActivityBaseVC {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var activityTitleLabel: UILabel!
    
    
    //TOTO we need to fnd way to link model with view/cell
    public var activity: ActivityModel?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    @IBAction func closeBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func setupUI() {
        scrollView.backgroundColor = activity?.bgColor
        activityTitleLabel.text = activity?.name
    }
    
}
