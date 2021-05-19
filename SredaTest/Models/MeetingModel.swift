//
//  MeetingModel.swift
//  SredaTest
//
//  Created by Dmitry Muravev on 18.05.2021.
//

import RealmSwift

class MeetingModel: Object {

    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var date = ""
    @objc dynamic var descr = ""
    @objc dynamic var organizator = ""

    override class func primaryKey() -> String? {
        return "id"
    }

    convenience init(id: Int, name: String, date: String, descr: String, organizator: String) {
        self.init()
        self.id = id
        self.name = name
        self.date = date
        self.descr = descr
        self.organizator = organizator
    }
}
