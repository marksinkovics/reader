import Foundation

class RFC822DateFormatter: DateFormatter {
    override init() {
        super.init()
        self.dateFormat = "EE, d MMM yyyy HH:mm:ss Z"
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.dateFormat = "EE, d MMM yyyy HH:mm:ss Z"
    }
}
