//
//  HSCardUseCaseTest.m
//  StoneNamuCoreTests
//
//  Created by Jinwoo Kim on 9/20/21.
//

#import <XCTest/XCTest.h>
#import <StoneNamuCore/HSCardUseCaseImpl.h>

@interface HSCardUseCaseTest : XCTestCase
@property (retain) id<HSCardUseCase> _Nullable hsCardUseCase;
@end

@implementation HSCardUseCaseTest

- (void)setUp {
    [super setUp];
    
    HSCardUseCaseImpl *hsCardUseCase = [HSCardUseCaseImpl new];
    self.hsCardUseCase = hsCardUseCase;
    [hsCardUseCase release];
}

- (void)tearDown {
    [super tearDown];
    self.hsCardUseCase = nil;
}

- (void)testFetchWithOptions {
    XCTestExpectation *expectation = [XCTestExpectation new];
    
    [self.hsCardUseCase fetchWithOptions:nil completionHandler:^(NSArray<HSCard *> * _Nullable hsCards, NSNumber * _Nullable pageCount, NSNumber * _Nullable page, NSError * _Nullable error) {
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
    
    [self.hsCardUseCase fetchWithIdOrSlug:[@13879 stringValue] withOptions:nil completionHandler:^(HSCard * _Nullable hsCard, NSError * _Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(hsCard);
        [expectation fulfill];
    }];
    
    XCTWaiterResult result = [XCTWaiter waitForExpectations:@[expectation] timeout:5];
    [expectation release];
    
    if (result != XCTWaiterResultCompleted) {
        XCTAssert("error!");
    }
}

@end
