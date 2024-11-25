import Foundation

protocol ImagesListViewPresenterProtocol {
    static var dateFormatter: DateFormatter { get }
    var view: ImagesListViewControllerProtocol? { get set }
    
    func fetchPhotosNextPage()
    func viewDidLoad() 
    func cellDidTap(indexPath: IndexPath)
}
