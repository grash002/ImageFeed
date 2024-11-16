import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    
    // MARK: - Public Properties
    
    var imageView: UIImageView = UIImageView()
    var imageUrl: URL?
    
    
    // MARK: - Private Properties
    
    private var scrollView = {
        let scrollView = UIScrollView()
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        return scrollView
    }()
    
    
    private var shareButton = {
        let shareButton = UIButton()
        shareButton.setTitle("", for: .normal)
        shareButton.setImage(UIImage(named: "Sharing"), for: .normal)
        shareButton.addTarget(self,
                              action: #selector(shareButtonDidTap),
                              for: .touchUpInside)
        return shareButton
    }()
    
    private var backButton = {
        let backButton = UIButton()
        backButton.setTitle("", for: .normal)
        backButton.setImage(UIImage(named: "Backward"), for: .normal)
        backButton.addTarget(self,
                             action: #selector(backButtonDidTap),
                             for: .touchUpInside)
        return backButton
    }()
    
    
    // MARK: - Overrides Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSingleImageView()
    }
    
    
    // MARK: - Private Methods
    func showError() {
        
        AlertPresenter.showAlert(delegate: self,
                                 alertModel: AlertModel(
                                    title: "Что-то пошло не так(",
                                    message: "Попробовать ещё раз?",
                                    actions: [UIAlertAction(title: "Не надо", style: .default),
                                              UIAlertAction(title: "Повторить", style: .default){[weak self]_ in
                                                  guard let self,
                                                        let imageUrl else { return }
                                                  self.setImage(with: imageUrl)
                                              }]
                                 )
        )
    }
    
    
    private func setImage(with imageUrl: URL) {
        UIBlockingProgressHUD.showWithOutAnim()
        guard let placeholderImage = UIImage(named: "SingleImageStub") else { return }
        imageView.frame.size = placeholderImage.size
        centerImage()
        
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: imageUrl,
                              placeholder: placeholderImage) { [weak self] result in
            UIBlockingProgressHUD.dismissWithOutAnim()
            guard let self = self else { return }
            switch result {
            case .success(let imageResult):
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure:
                UIBlockingProgressHUD.dismiss()
                self.showError()
            }
        }
    }
    
    
    private func setSingleImageView() {
        view.backgroundColor = UIColor(named: "YPBlack")
        
        scrollView.frame = view.bounds
        scrollView.delegate = self
        scrollView.maximumZoomScale = 1
        
        guard let imageUrl else { return }
        
        
        scrollView.addSubview(imageView)
        view.addSubview(scrollView)
        view.addSubview(shareButton)
        view.addSubview(backButton)
        
        
        [scrollView,
         imageView ,
         shareButton,
         backButton].forEach() {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            
            backButton.heightAnchor.constraint(equalToConstant: 48),
            backButton.widthAnchor.constraint(equalToConstant: 48),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 9),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 9),
            
            shareButton.heightAnchor.constraint(equalToConstant: 50),
            shareButton.widthAnchor.constraint(equalToConstant: 50),
            shareButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shareButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        imageView.contentMode = .scaleAspectFit
        setImage(with: imageUrl)
    }
    
    
    @objc
    private func backButtonDidTap() {
        dismiss(animated: true, completion: nil)
    }
    
    
    @objc
    private func shareButtonDidTap(_ sender: Any) {
        guard let image = imageView.image else { return }
        let share = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }
    
    
    private func centerImage() {
        
        let scrollViewSize = scrollView.bounds.size
        let imageViewSize = imageView.frame.size
        let horizontalInset = max(0, (scrollViewSize.width - imageViewSize.width) / 2)
        let verticalInset = max(0, (scrollViewSize.height - imageViewSize.height) / 2)
        
        scrollView.contentInset = UIEdgeInsets(top: verticalInset,
                                               left: horizontalInset,
                                               bottom: verticalInset,
                                               right: horizontalInset)
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        guard let image = imageView.image else { return }
        
        imageView.bounds.size = image.size
        let scrollViewSize = scrollView.bounds.size
        let widthScale = scrollViewSize.width / image.size.width
        let heightScale = scrollViewSize.height / image.size.height
        let minScale = min(widthScale, heightScale)
        
        
        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = minScale
        
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
