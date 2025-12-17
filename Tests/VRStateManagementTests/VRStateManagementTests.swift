import XCTest
@testable import VRStateManagement

final class VRStateManagementTests: XCTestCase {
    
    func testLoadStateInitialState() {
        let state = LoadState<String>.initial
        
        if case .initial = state {
            XCTAssertTrue(true)
        } else {
            XCTFail("Expected initial state")
        }
    }
    
    func testLoadStateLoading() {
        let state = LoadState<String>.loading
        
        if case .loading = state {
            XCTAssertTrue(true)
        } else {
            XCTFail("Expected loading state")
        }
    }
}
