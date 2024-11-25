import Foundation
import UIKit

protocol ImagesListViewControllerProtocol: UIViewController {
    var presenter: ImagesListViewPresenterProtocol? { get set }
    
    var photos: [Photo] { get set }
    var mockPhoto: Photo? { get }
    var tableView: UITableView {get set}

    func updateTableViewAnimated(fromIndex: Int, toIndex: Int)
}
