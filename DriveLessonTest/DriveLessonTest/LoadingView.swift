import UIKit

class LoadingView: UIView {

    func show() {
        if self.isHidden {
            self.isHidden = false
            UIView.animate(withDuration: 0.25) {
                self.alpha = 0.75
            }
        }
    }
    
    func hide() {
        if !self.isHidden {
            UIView.animate(withDuration: 0.5, animations: {
                self.alpha = 0
            }) { (b) in
                self.isHidden = true
            }
        }
    }
}
