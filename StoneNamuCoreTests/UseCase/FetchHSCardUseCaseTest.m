//
//  FetchHSCardUseCaseTest.m
//  StoneNamuCoreTests
//
//  Created by Jinwoo Kim on 7/18/21.
//

#import <XCTest/XCTest.h>
#import "FetchHSCardUseCaseImpl.h"

@interface FetchHSCardUseCaseTest : XCTestCase
@property (retain) id<FetchHSCardUseCase> useCase;
@end

@implementation FetchHSCardUseCaseTest

- (void)setUp {
    FetchHSCardUseCaseImpl *useCase = [FetchHSCardUseCaseImpl new];
    self.useCase = useCase;
    [useCase release];
}

- (void)dealloc {
    [_useCase release];
    [super dealloc];
}

- (void)testFetchCards {
    XCTestExpectation *expectation = [XCTestExpectation new];
    
    [self.useCase fetchWithOptions:nil
                 completionHandler:^(NSArray<HSCard *> * _Nullable cards, NSError * _Nullable error) {
        NSLog(@"%@", cards);
        NSLog(@"%@", error);
        [expectation fulfill];
    }];
    
    XCTWaiterResult result = [XCTWaiter waitForExpectations:@[expectation] timeout:5];
    
    switch (result) {
        case XCTWaiterResultTimedOut:
            XCTAssert("time out!");
            break;
        default:
            break;
    }
}

- (void)testFetchCard {
    XCTestExpectation *expectation = [XCTestExpectation new];
    
    [self.useCase fetchWithIdOrSlug:@"36"
                        withOptions:nil
                  completionHandler:^(HSCard * _Nullable card, NSError * _Nullable error) {
        NSLog(@"%@", card);
        [expectation fulfill];
    }];
    
    XCTWaiterResult result = [XCTWaiter waitForExpectations:@[expectation] timeout:5];
    
    switch (result) {
        case XCTWaiterResultTimedOut:
            XCTAssert("time out!");
            break;
        default:
            break;
    }
}

@end
