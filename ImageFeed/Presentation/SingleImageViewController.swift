import UIKit

final class SingleImageViewController: UIViewController {

    // MARK: - IB Outlets
    
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var backButton: UIButton!

    
    // MARK: - Public Properties
    
    var image: UIImage? {
        didSet {
            guard isViewLoaded, let image else { return }

            imageView.image = image
            imageView.frame.size = image.size
            rescaleAndCenterImageInScrollView(image: image)
        }
    }


    // MARK: - Overrides Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        
        backButton.setTitle("", for: .normal)
        shareButton.setTitle("", for: .normal)
        
        guard let image else { return }
        imageView.image = image
        imageView.frame.size = image.size
        rescaleAndCenterImageInScrollView(image: image)
    }

    
    // MARK: - IB Actions
    
    @IBAction private func backButtonDidTap() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareButtonDidTap(_ sender: Any) {
        guard let image else { return }
        let share = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }
    
    
    // MARK: - Private Methods
    
    private func centerImage() {
        let scrollViewSize = scrollView.bounds.size
        let imageSize = imageView.frame.size
        let horizontalPadding = (scrollViewSize.width - imageSize.width) / 2
        let verticalPadding = (scrollViewSize.height - imageSize.height) / 2

        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, 
                                               left: horizontalPadding, 
                                               bottom: verticalPadding,
                                               right: horizontalPadding)
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, 
                        max(minZoomScale, min(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        
        centerImage()
    }
}



// MARK: - Extensions

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImage()
    }
}
