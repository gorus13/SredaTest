//
//  ShowScreenViewController.swift
//  SredaTest
//
//  Created by Dmitry Muravev on 18.05.2021.
//

import UIKit
import RxSwift
import RxCocoa

class ShowScreenViewController: UIViewController, BindableType {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var organizatorLabel: UILabel!
    
    private let disposeBag = DisposeBag()
    
    var viewModel: ShowScreenViewModelType!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func bindViewModel() {
        let inputs = viewModel.inputs
        let outputs = viewModel.outputs
        
        outputs.meetingName
            .bind(to: nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        outputs.meetingDate
            .bind(to: dateLabel.rx.text)
            .disposed(by: disposeBag)
        
        outputs.meetingDescription
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        outputs.meetingOrganizator
            .bind(to: organizatorLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
