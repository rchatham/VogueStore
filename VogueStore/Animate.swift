//
//  Animate.swift
//  VogueStore
//
//  Created by Reid Chatham on 10/17/16.
//  Copyright © 2016 Reid Chatham. All rights reserved.
//

import UIKit

typealias Animation = (Void)->Void
typealias Wait = (@escaping Animation)->Void

enum Operation {
    case animation(TimeInterval, Animation)
    case wait(Wait)
}

class Animate {
    
    private var animations = Queue<Operation>()
    
    init(duration: TimeInterval, _ callback: @escaping Animation) {
        animations.enqueue(data: .animation(duration,callback))
    }
    
    func then(duration: TimeInterval, _ callback: @escaping Animation) -> Animate {
        animations.enqueue(data: .animation(duration,callback))
        return self
    }
    
    func wait(_ callback: @escaping Wait) -> Animate {
        animations.enqueue(data: .wait(callback))
        return self
    }
    
    func perform() {
        guard let operation = animations.dequeue() else { return }
        switch operation {
        case .animation(let duration, let animation):
            UIView.animate(withDuration: duration, animations: animation) { (success) in
                self.perform()
            }
        case .wait(let callback):
            callback {
                self.perform()
            }
        }
    }
}
