//
//  EnumeratedViewTests.swift
//  SwiftCSV
//
//  Created by Christian Tietze on 2016-10-25.
//  Copyright © 2016 Naoto Kaneko. All rights reserved.
//

import XCTest
@testable import SwiftCSV

class EnumeratedViewTests: XCTestCase {

    var csv: CSV<EnumeratedView>!

    override func setUp() {
        super.setUp()

        csv = try! CSV<EnumeratedView>(string: "id,name,age\n1,Alice,18\n2,Bob,19\n3,Charlie,20", delimiter: ",", loadColumns: true)
    }

    func testExposesRows() {
        let expected: [[String]] = [
            ["1", "Alice", "18"],
            ["2", "Bob", "19"],
            ["3", "Charlie", "20"]
        ]
        let actual = csv.rows

        // Abort if counts don't match to not raise index-out-of-bounds exception
        guard actual.count == expected.count else {
            XCTFail("expected actual.count (\(actual.count)) to equal expected.count (\(expected.count))")
            return
        }

        for i in actual.indices {
            XCTAssertEqual(actual[i], expected[i])
        }
    }

    func testExposesColumns() {
        let actual = csv.columns

        // Abort if counts don't match to not raise index-out-of-bounds exception
        guard actual.count == 3 else {
            XCTFail("expected actual.count to equal 3")
            return
        }

        XCTAssertEqual(actual[0].header, "id")
        XCTAssertEqual(actual[0].rows, ["1", "2", "3"])

        XCTAssertEqual(actual[1].header, "name")
        XCTAssertEqual(actual[1].rows, ["Alice", "Bob", "Charlie"])

        XCTAssertEqual(actual[2].header, "age")
        XCTAssertEqual(actual[2].rows, ["18", "19", "20"])
    }

    func testSerialization() {
        XCTAssertEqual(csv.serialized, "id,name,age\n1,Alice,18\n2,Bob,19\n3,Charlie,20")
    }

    func testSerializationWithDoubleQuotes() {
        csv = try! CSV<EnumeratedView>(string: "id,\"the, name\",age\n1,\"Alice, In, Wonderland\",18\n2,Bob,19\n3,Charlie,20")
        XCTAssertEqual(csv.serialized, "id,\"the, name\",age\n1,\"Alice, In, Wonderland\",18\n2,Bob,19\n3,Charlie,20")
    }
}
