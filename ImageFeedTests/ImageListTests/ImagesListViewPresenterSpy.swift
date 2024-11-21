@testable import ImageFeed
import Foundation

final class ImagesListViewPresenterSpy: ImagesListViewPresenterProtocol {

    
    static var dateFormatter: DateFormatter = DateFormatter()
    
    var viewDidLoadCalled: Bool = false
    var fetchPhotosNextPageCalled: Bool = false
    var view: ImagesListViewControllerProtocol?

    func viewDidLoad() {
        viewDidLoadCalled = true
    }
        
    func cellDidTap(indexPath: IndexPath) {
        
    }    
    func fetchPhotosNextPage() {
        
    }
}

