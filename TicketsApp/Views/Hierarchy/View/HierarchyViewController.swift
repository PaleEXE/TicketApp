//
//  HierarchyViewController.swift
//  TicketsApp
//
//  Created by test on 13/07/2026.
//

import UIKit
import RxSwift

class HierarchyViewController: AppViewController {
    @IBOutlet weak var profileDetailsButton: RoundedView!

    override func viewDidLoad() {
        title = "My Hierarchy"
        setupUI()
    }
}
