import XCTest

final class ImageFeedUITests: XCTestCase {

    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    func testAuth() throws {
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        XCTAssert(webView.waitForExistence(timeout: 5))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssert(loginTextField.waitForExistence(timeout: 5))
        
        loginTextField.tap()
        loginTextField.typeText("mail@mail.ru")
        loginTextField.swipeUp()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssert(passwordTextField.waitForExistence(timeout: 5))
        
        passwordTextField.tap()
        passwordTextField.typeText("Password!")
        webView.tap()
        print(app.debugDescription)
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssert(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() throws {
        let tablesQuery = app.tables
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssert(cell.waitForExistence(timeout: 5.0), "First cell does not exist")
        cell.swipeUp()
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        XCTAssert(cellToLike.waitForExistence(timeout: 5.0), "Cell for like does not exist")
        
        let likeButton = cellToLike.buttons["like button"]
        XCTAssert(likeButton.waitForExistence(timeout: 5.0), "Like button does not exist")
        likeButton.tap()
        

        cellToLike.tap()
        let scrollView = app.scrollViews.firstMatch
        XCTAssert(scrollView.waitForExistence(timeout: 5.0), "ScrollView does not exist")
        
        let image = scrollView.images.element(boundBy: 0)
        XCTAssert(image.waitForExistence(timeout: 5.0), "image does not exist")
        
        
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButtonWhiteButton = app.buttons["nav back button white"]
        XCTAssert(navBackButtonWhiteButton.waitForExistence(timeout: 5.0), "nav back button does not exist")
        navBackButtonWhiteButton.tap()
    }
    
    func testProfile() throws {
        
        let tabBarButton = app.tabBars.buttons.element(boundBy: 1)
        XCTAssert(tabBarButton.waitForExistence(timeout: 5.0), "tabBarButton does not exist")
        tabBarButton.tap()
        
        XCTAssertTrue(app.staticTexts["Name Name"].exists)
        XCTAssertTrue(app.staticTexts["@username"].exists)
            
        let logoutButton = app.buttons["logout button"]
        XCTAssert(logoutButton.waitForExistence(timeout: 5.0), "logoutButton does not exist")
        logoutButton.tap()
        
        let alert = app.alerts["Пока, пока!"]
        XCTAssert(alert.waitForExistence(timeout: 5.0), "alert does not exist")
        
        let yesButton = alert.scrollViews.otherElements.buttons["Да"]
        XCTAssert(yesButton.waitForExistence(timeout: 5.0), "yesButton does not exist")
        yesButton.tap()
        
    }
}
