//
//  InputScreenViewController.swift
//  SredaTest
//
//  Created by Dmitry Muravev on 18.05.2021.
//

import UIKit
import RxSwift
import RxCocoa

class InputScreenViewController: UIViewController, BindableType {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var organizatorTextField: UITextField!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    @IBOutlet weak var saveButton: UIButton!
    
    private let disposeBag = DisposeBag()
    
    var viewModel: InputScreenViewModelType!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        activityView.isHidden = true
    }

    func bindViewModel() {
        let inputs = viewModel.inputs
        let outputs = viewModel.outputs
        
        nameTextField.rx.text.orEmpty
            .bind(to: inputs.meetingName)
            .disposed(by: disposeBag)
        
        dateTextField.rx.text.orEmpty
            .bind(to: inputs.meetingDate)
            .disposed(by: disposeBag)
        
        descriptionTextField.rx.text.orEmpty
            .bind(to: inputs.meetingDescription)
            .disposed(by: disposeBag)
        
        organizatorTextField.rx.text.orEmpty
            .bind(to: inputs.meetingOrganizator)
            .disposed(by: disposeBag)
        
        saveButton.rx.action = inputs.saveAction
        
        outputs.saveIndicatorShow.subscribe(
            onNext: { [weak self] value in
                value ? self?.showLoading() : self?.hideLoading()
            }).disposed(by: disposeBag)
    }
    
    func showLoading() {
        activityView.isHidden = false
        activityView.startAnimating()
        saveButton.isHidden = true
    }
    
    func hideLoading() {
        activityView.isHidden = true
        saveButton.isHidden = false
    }
}
