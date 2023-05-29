import Panda
import UIKit

public class PDComponents {
    public private(set) var text = "Hello, World!"
}

public extension PDComponents {
    func sayHello() {
        Log.info(text)
    }
}
