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
    //private var loading:[String:Task<String, Never>]

    init() {
        values = Dictionary(minimumCapacity: 20)
        //loading = [:]
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
    package let charset:String, title:String, keywords:[String], meta_description:String
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
        title = "DynamicView"
        keywords = ["swift", "html", "benchmark"]
        meta_description = "This website is to benchmark the performance of different Swift DSL libraries."

        heading = "Dynamic HTML Benchmark"
        desc_id = "desc"
        // 5 paragraphs of lorem ipsum
        let lorem_ipsum:String = """
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse eget ornare ligula, sit amet pretium justo. Nunc vestibulum sollicitudin sem sed ultricies. Nullam ultrices mattis rutrum. Quisque venenatis lacus non tortor aliquam elementum. Nullam dictum, dolor vel efficitur semper, metus nisi porta elit, in tincidunt nunc eros quis nunc. Aliquam id eros sed leo feugiat aliquet quis eget augue. Praesent molestie quis libero vulputate cursus. Aenean lobortis cursus lacinia. Quisque imperdiet suscipit mi in rutrum. Suspendisse potenti.

        In condimentum non turpis non porta. In vehicula rutrum risus eget placerat. Nulla neque quam, dignissim eu luctus at, elementum at nisl. Cras volutpat mi sem, at congue felis pellentesque sed. Sed maximus orci vel enim iaculis condimentum. Integer maximus consectetur arcu quis aliquet. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Maecenas eget feugiat elit. Maecenas pellentesque, urna at iaculis pretium, diam lectus dapibus est, et fermentum nisl ex vel ligula. Aliquam dignissim dapibus est, nec tincidunt tortor sagittis in. Vestibulum id lacus a nunc auctor ultricies. Praesent ante sapien, ultricies vel lorem id, tempus mollis justo. Curabitur sollicitudin, augue hendrerit suscipit tristique, sem lacus consectetur leo, id eleifend diam tellus sit amet nulla. Etiam metus augue, consequat ut dictum a, aliquet nec neque. Vestibulum gravida vel ligula at interdum. Nam cursus sapien non malesuada lobortis.

        Nulla in viverra mauris. Pellentesque non sollicitudin lacus, vitae pharetra neque. Praesent sodales odio nisi, quis condimentum orci ornare a. Aliquam erat volutpat. Maecenas purus mauris, aliquet rutrum metus eget, consectetur fringilla felis. Proin pulvinar tellus nulla, nec iaculis neque venenatis sed. In vel dui quam. Integer aliquam ligula ipsum, mattis commodo quam elementum ut. Aenean tortor neque, blandit fermentum velit ut, rutrum gravida ex.

        Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec sed diam eget nibh semper varius. Phasellus sed feugiat turpis, sit amet pharetra erat. Integer eleifend tortor ut mauris lobortis consequat. Aliquam fermentum mollis fringilla. Morbi et enim in ligula luctus facilisis quis sed leo. Nullam ut suscipit arcu, eu hendrerit eros. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla maximus tempus dui. In aliquam neque ut urna euismod, vitae ullamcorper nisl fermentum. Integer ac ultricies erat, id volutpat leo. Morbi faucibus tortor at lectus feugiat, quis ultricies lectus dictum. Pellentesque congue blandit ligula, nec convallis lectus volutpat congue. Nam lobortis sapien nec nulla accumsan, a pharetra quam convallis. Donec vulputate rutrum dolor ac cursus. Mauris condimentum convallis malesuada.

        Mauris eros quam, dictum id elementum et, pharetra in metus. Quisque fermentum congue risus, accumsan consectetur neque aliquam quis. Vestibulum ipsum massa, euismod faucibus est in, condimentum venenatis risus. Quisque congue vehicula tellus, et dignissim augue accumsan ac. Pellentesque tristique ornare ligula, vitae iaculis dui varius vel. Ut sed sem sed purus facilisis porta quis eu tortor. Donec in vehicula tortor. Sed eget aliquet enim. Mauris tincidunt placerat risus, ut gravida lacus vehicula eget. Curabitur ultrices sapien tortor, eu gravida velit efficitur sed. Suspendisse eu volutpat est, ut bibendum velit. Maecenas mollis sit amet sapien laoreet pulvinar. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Morbi lorem ante, volutpat et accumsan a, fermentum vel metus.
        """
        var string:String = ""
        for _ in 0..<10 {
            string += lorem_ipsum
        }
        self.string = string

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