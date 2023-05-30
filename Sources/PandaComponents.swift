import Panda
import UIKit

public class PandaComponents {
    public private(set) var text = "Hello, World!"
}

public extension PandaComponents {
    func sayHello() {
        Log.info(text)
    }
}
