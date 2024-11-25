@testable import ImageFeed
import UIKit

final class ImagesListViewControllerSpy: UIViewController, ImagesListViewControllerProtocol {
    var presenter: (any ImageFeed.ImagesListViewPresenterProtocol)?
    var updateTableViewAnimatedDidCalled = false
    
    var photos: [ImageFeed.Photo] = []
    
    var mockPhoto: ImageFeed.Photo?
    
    var tableView: UITableView = UITableView()
    
    func updateTableViewAnimated(fromIndex: Int, toIndex: Int) {
        updateTableViewAnimatedDidCalled = true
    }
    
    
}
