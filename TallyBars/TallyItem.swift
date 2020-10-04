//
//  TallyItem.swift
//  TallyBars
//
//  Created by Daniel Marriner on 03/10/2020.
//

import FluentSQLiteDriver

final class TallyItem: Model {
    static var schema: String = "tallyItems"

    @ID(custom: "id")
    var id: Int?

    @Parent(key: "list")
    var list: TallyList

    @Field(key: "name")
    var name: String

    init() {}

    init(id: Int? = nil, listId: Int, name: String) {
        self.id = id
        self.$list.id = listId
        self.name = name
    }
}

extension TallyItem: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(TallyItem.schema)
            .field("id", .int, .identifier(auto: true))
            .field("list", .int, .required)
            .foreignKey("list", references: TallyList.schema, .id, onDelete: .cascade, onUpdate: .noAction)
            .field("name", .string, .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(TallyItem.schema).delete()
    }
}

