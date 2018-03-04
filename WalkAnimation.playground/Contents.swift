import UIKit
import PlaygroundSupport

class ViewController: UIViewController {
    var imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    var animator: UIViewPropertyAnimator!
    let images: [UIImage] = [UIImage(named: "static.png")!, UIImage(named: "walk1.png")!, UIImage(named: "walk2.png")!]
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        view.addSubview(imageView)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(pan(_:)))
        imageView.addGestureRecognizer(pan)
        imageView.animationImages = images
        imageView.animationDuration = 0.5
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        imageView.center.y = view.center.y
        imageView.startAnimating()
        animator = UIViewPropertyAnimator.init(duration: 5, curve: .easeInOut) {
            self.imageView.center.x = self.view.bounds.maxX - self.imageView.bounds.size.width
        }
        animator.addCompletion { _ in
            self.imageView.stopAnimating()
            self.imageView.image = UIImage(named: "static.png")!
        }
        animator.isUserInteractionEnabled = true
        animator.startAnimation()
    }

    @objc private func pan(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began, .changed:
            animator.stopAnimation(true)
            let delta = recognizer.translation(in: imageView)
            imageView.center.x += delta.x
            recognizer.setTranslation(.zero, in: imageView)
        case .ended, .cancelled:
            imageView.startAnimating()
            animator = UIViewPropertyAnimator(duration: 5, curve: .easeInOut) {
                self.imageView.center.x = self.view.bounds.maxX - self.imageView.bounds.size.width
            }
            animator.addCompletion { _ in
                self.imageView.stopAnimating()
                self.imageView.image = UIImage(named: "static.png")!
            }
            animator.startAnimation()
            break
        default:
            break
        }
    }
}

PlaygroundPage.current.liveView = ViewController()


