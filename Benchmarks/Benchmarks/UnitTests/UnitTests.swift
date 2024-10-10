//
//  UnitTests.swift
//
//
//  Created by Evan Anderson on 10/6/24.
//

import Testing
import Utilities

import TestVaux

struct UnitTests {
    @Test func vaux() {
        #expect(VauxTests().staticHTML() != "")
    }
}