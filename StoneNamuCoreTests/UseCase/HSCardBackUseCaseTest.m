//
//  HSCardBackUseCaseTest.m
//  StoneNamuCoreTests
//
//  Created by Jinwoo Kim on 3/5/22.
//

#import <XCTest/XCTest.h>
#import <StoneNamuCore/HSCardBackUseCaseImpl.h>

@interface HSCardBackUseCaseTest : XCTestCase
@property (retain) id<HSCardBackUseCase> _Nullable hsCardBackUseCase;
@end

@implementation HSCardBackUseCaseTest

- (void)dealloc {
    [_hsCardBackUseCase release];
    [super dealloc];
}

- (void)setUp {
    [super setUp];
    
    HSCardBackUseCaseImpl *hsCardBackUseCase = [HSCardBackUseCaseImpl new];
    self.hsCardBackUseCase = hsCardBackUseCase;
    [hsCardBackUseCase release];
}

- (void)tearDown {
    [super tearDown];
    self.hsCardBackUseCase = nil;
}

- (void)testFetchWithOptions {
    XCTestExpectation *expectation = [XCTestExpectation new];
    
    [self.hsCardBackUseCase fetchWithOptions:nil completionHandler:^(NSArray<HSCardBack *> * _Nullable hsCardBacks, NSNumber * _Nullable pageCount, NSNumber * _Nullable page, NSError * _Nullable error) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    
    XCTWaiterResult result = [XCTWaiter waitForExpectations:@[expectation] timeout:5];
    [expectation release];
    
    if (result != XCTWaiterResultCompleted) {
        XCTAssert("error!");
    }
}

- (void)testFetchWithIdOrSlug {
    XCTestExpectation *expectation = [XCTestExpectation new];
    
    [self.hsCardBackUseCase fetchWithIdOrSlug:@"150" withOptions:nil completionHandler:^(HSCardBack * _Nullable hsCardBack, NSError * _Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(hsCardBack);
        [expectation fulfill];
    }];
    
    XCTWaiterResult result = [XCTWaiter waitForExpectations:@[expectation] timeout:5];
    [expectation release];
    
    if (result != XCTWaiterResultCompleted) {
        XCTAssert("error!");
    }
}

@end
