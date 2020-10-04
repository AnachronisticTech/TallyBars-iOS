//
//  TallyList.swift
//  TallyBars
//
//  Created by Daniel Marriner on 03/10/2020.
//

import FluentSQLiteDriver

final class TallyList: Model {
    static var schema: String = "tallyLists"

    @ID(custom: "id")
    var id: Int?

    @Field(key: "name")
    var name: String

    @Children(for: \.$list)
    var items: [TallyItem]

    init() {}

    init(id: Int? = nil, name: String) {
        self.id = id
        self.name = name
    }
}

extension TallyList: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(TallyList.schema)
            .field("id", .int, .identifier(auto: true))
            .field("name", .string, .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(TallyList.schema).delete()
    }
}
