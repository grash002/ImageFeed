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
        loginTextField.typeText("Mail@mail.ru")
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
        cell.swipeUp()
        
        sleep(2)
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        
        cellToLike.buttons["like button"].tap()

        
        sleep(2)
        cellToLike.tap()
        sleep(2)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        
        
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButtonWhiteButton = app.buttons["nav back button white"]
        navBackButtonWhiteButton.tap()
    }
    
    func testProfile() throws {
            sleep(5)
            app.tabBars.buttons.element(boundBy: 1).tap()
            sleep(2)
            XCTAssertTrue(app.staticTexts["Name Lastname"].exists)
            XCTAssertTrue(app.staticTexts["@username"].exists)
            
            app.buttons["logout button"].tap()
            
            app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()
        
    }
}
