//
//  InputScreenViewModel.swift
//  SredaTest
//
//  Created by Dmitry Muravev on 18.05.2021.
//

import Foundation
import RxSwift
import Action

protocol InputScreenViewModelInput {
    var saveAction: CocoaAction { get }
    var meetingName: BehaviorSubject<String> { get }
    var meetingDate: BehaviorSubject<String> { get }
    var meetingDescription: BehaviorSubject<String> { get }
    var meetingOrganizator: BehaviorSubject<String> { get }
}

protocol InputScreenViewModelOutput {
    var saveIndicatorShow: BehaviorSubject<Bool> { get }
}

protocol InputScreenViewModelType {
    var inputs: InputScreenViewModelInput { get }
    var outputs: InputScreenViewModelOutput { get }
}

final class InputScreenViewModel: InputScreenViewModelInput,
                                  InputScreenViewModelOutput,
                                  InputScreenViewModelType  {

    var inputs: InputScreenViewModelInput { return self }
    var outputs: InputScreenViewModelOutput { return self }
    
    let meetingName = BehaviorSubject<String>(value: "")
    let meetingDate = BehaviorSubject<String>(value: "")
    let meetingDescription = BehaviorSubject<String>(value: "")
    let meetingOrganizator = BehaviorSubject<String>(value: "")
    
    var saveIndicatorShow = BehaviorSubject<Bool>(value: false)

    lazy var saveAction: CocoaAction = {
        CocoaAction { [unowned self] _ in
            saveIndicatorShow.onNext(true)
            let result = Observable.combineLatest(self.meetingName, self.meetingDate, self.meetingDescription, self.meetingOrganizator)
                .take(1)
                .delay(.seconds(3), scheduler: MainScheduler.instance)
                .flatMap { [unowned self] name, date, description, organizator -> Observable<MeetingModel> in
                    let newModel = MeetingModel(id: 0, name: name, date: date, descr: description, organizator: organizator)
                    self.storageManager.save(object: newModel, update: true)
                    self.saveIndicatorShow.onNext(false)
                    return .just(newModel)
                }
            return result.ignoreAll()
        }
    }()
    
    private var meetingModel: MeetingModel?
    private let sceneCoordinator: SceneCoordinatorType
    private let storageManager: StorageManager

    init( storageManager: StorageManager = StorageManager.shared, sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared) {
        self.sceneCoordinator = sceneCoordinator
        self.storageManager = storageManager
     
        if let model = storageManager.getMeeting(id: 0) {
            self.meetingModel = model
        } else {
            let newMeetingModel = MeetingModel(id: 0, name: "", date: "", descr: "", organizator: "")
            storageManager.save(object: newMeetingModel, update: true)
            self.meetingModel = newMeetingModel
        }
    }
}
