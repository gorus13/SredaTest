//
//  ShowScreenViewModel.swift
//  SredaTest
//
//  Created by Dmitry Muravev on 18.05.2021.
//

import Foundation
import RxSwift
import Action
import RealmSwift

protocol ShowScreenViewModelInput {
}

protocol ShowScreenViewModelOutput {
    var meetingName: BehaviorSubject<String> { get }
    var meetingDate: BehaviorSubject<String> { get }
    var meetingDescription: BehaviorSubject<String> { get }
    var meetingOrganizator: BehaviorSubject<String> { get }
}

protocol ShowScreenViewModelType {
    var inputs: ShowScreenViewModelInput { get }
    var outputs: ShowScreenViewModelOutput { get }
}

final class ShowScreenViewModel: ShowScreenViewModelInput,
                                 ShowScreenViewModelOutput,
                                  ShowScreenViewModelType  {

    var inputs: ShowScreenViewModelInput { return self }
    var outputs: ShowScreenViewModelOutput { return self }

    let meetingName = BehaviorSubject<String>(value: "")
    var meetingDate = BehaviorSubject<String>(value: "")
    var meetingDescription = BehaviorSubject<String>(value: "")
    var meetingOrganizator = BehaviorSubject<String>(value: "")
    
    private var meetingModel: MeetingModel?
    private let sceneCoordinator: SceneCoordinatorType
    private let storageManager: StorageManager
    
    var realmNotificationToken: NotificationToken?
    
    init( storageManager: StorageManager = StorageManager.shared, sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared) {
        self.sceneCoordinator = sceneCoordinator
        self.storageManager = storageManager
        
        self.meetingModel = storageManager.getMeeting(id: 0)
            
        self.meetingName.onNext(self.meetingModel?.name ?? "")
        self.meetingDate.onNext(self.meetingModel?.date ?? "")
        self.meetingDescription.onNext(self.meetingModel?.descr ?? "")
        self.meetingOrganizator.onNext(self.meetingModel?.organizator ?? "")
            
        realmNotificationToken = self.meetingModel?.observe { [weak self] _ in
            self?.meetingModel = storageManager.getMeeting(id: 0)
                
            self?.meetingName.onNext(self?.meetingModel?.name ?? "")
            self?.meetingDate.onNext(self?.meetingModel?.date ?? "")
            self?.meetingDescription.onNext(self?.meetingModel?.descr ?? "")
            self?.meetingOrganizator.onNext(self?.meetingModel?.organizator ?? "")
        }
        
    }
    
    deinit {
        realmNotificationToken?.invalidate()
    }
}
