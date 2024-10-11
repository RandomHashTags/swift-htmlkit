//
//  Utilities.swift
//
//
//  Created by Evan Anderson on 10/5/24.
//

import Foundation

// MARK: HTMLGenerator
package protocol HTMLGenerator {
    init()
    func staticHTML() -> String

    func dynamicHTML(_ context: HTMLContext) -> String
}

// MARK: Simple cache
package actor Cache {
    private var values:[String:String]

    init() {
        values = Dictionary(minimumCapacity: 20)
    }

    func get(id: String, _ onLoad: () -> String) async -> String {
        if let cached:String = values[id] {
            return cached
        }
        let value:String = onLoad()
        values[id] = value
        return value
    }
}

// MARK: HTMLContext
package struct HTMLContext {
    package let charset:String, keywords:[String], meta_description:String
    package let heading:String, desc_id:String
    package let string:String, integer:Int, double:Double, float:Float, boolean:Bool
    package let now:Date
    package let user:User

    package var keywords_string : String {
        var s:String = ""
        for keyword in keywords {
            s += "," + keyword
        }
        s.removeFirst()
        return s
    }

    package init() {
        charset = "utf-8"
        keywords = ["swift", "html", "benchmark"]
        meta_description = "This website is to benchmark the performance of different Swift DSL libraries."

        heading = "Dynamic HTML Benchmark"
        desc_id = "desc"
        // 1 paragraph of lorem ipsum
        string = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam tempor euismod arcu, sed elementum erat lobortis vel. Fusce nec orci purus. Maecenas a rutrum elit, in pellentesque nisl. Cras nec dapibus turpis. Donec finibus auctor arcu, vehicula maximus eros tincidunt et. Praesent nulla urna, imperdiet quis nunc id, auctor varius justo. Integer fringilla tincidunt lectus, et egestas massa molestie ut. Aliquam at augue pulvinar ante dignissim dignissim a at augue. Donec nisi elit, faucibus a ante a, interdum ultrices lacus. Fusce faucibus odio at est imperdiet, id sodales ipsum hendrerit. Nullam vehicula velit non metus malesuada ornare. Proin consequat id nulla sed porttitor."
        integer = 293785
        double = 39848.9348019843
        float = 616905.2098238
        boolean = true

        now = Date.now

        user = User()
    }
}
package struct User {
    package let details_heading:String, qualities_heading:String, qualities_id:String

    package let id:UInt64, email:String, username:String
    package let qualities:[String]
    package let comment_ids:Set<Int>

    init() {
        details_heading = "User Details"
        qualities_heading = "Qualities"
        qualities_id = "user-qualities"

        id = 63821
        email = "test@gmail.com"
        username = "User \(id)"
        qualities = ["funny", "smart", "beautiful", "open-minded", "friendly", "hard-working", "team-player"]
        comment_ids = [895823, 293, 2384, 1294, 93, 872341, 2089792, 7823, 504985, 35590]
    }
}