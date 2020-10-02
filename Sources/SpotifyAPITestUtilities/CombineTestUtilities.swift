import Foundation
import Combine
import XCTest

public extension Publisher {
    
    /**
     Calls through to `XCTFail` when an error is received
     and replaces the error with a publisher that completes
     immediately successfully: `Empty<Output, Failure>`. This ensures that
     when this method is used multiple times in a publishing stream,
     the same error will not get logged by additional downstream calls.
     */
    func XCTAssertNoFailure(
        _ message: String = "",
        file: StaticString = #file,
        line: UInt = #line
     ) -> AnyPublisher<Output, Failure> {
        
        return self.catch { error -> Empty<Output, Failure> in
            XCTFail("\(message): \(error)", file: file, line: line)
            return Empty<Output, Failure>(completeImmediately: true)
        }
        .eraseToAnyPublisher()
        
    }
    
    /// Calls through to `sink` and uses an empty closure
    /// to receive the completion.
    func sinkIgnoringCompletion(
        _ receiveValue: @escaping ((Self.Output) -> Void)
    ) -> AnyCancellable {
        
        return self.sink(
            receiveCompletion: { _ in },
            receiveValue: receiveValue
        )
        
    }

}