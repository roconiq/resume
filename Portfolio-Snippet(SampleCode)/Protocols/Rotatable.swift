

import Foundation
import CoreAnimator

protocol Rotatable where Self: UIButton {
    var animator: CoreAnimator { get }
    
    func rotate()
}

extension Rotatable {
    
    func rotate() {
        animator.rotate(angle: 135).bounce.animate(t: 0.25)
    }
}

