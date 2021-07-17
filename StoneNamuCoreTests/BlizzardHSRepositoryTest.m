//
//  BlizzardHSRepositoryTest.m
//  StoneNamuCoreTests
//
//  Created by Jinwoo Kim on 7/17/21.
//

#import <XCTest/XCTest.h>
#import "BlizzardHSRepositoryImpl.h"
#import "BlizzardHSAPIKeys.h"
#import "BlizzardHSAPILocale.h"

@interface BlizzardHSRepositoryTest : XCTestCase
@property (retain) NSObject<BlizzardHSRepository> *repo;
@end

@implementation BlizzardHSRepositoryTest

- (void)setUp {
    NSObject<BlizzardHSRepository> *repo = [BlizzardHSRepositoryImpl new];
    self.repo = repo;
    [repo release];
}

- (void)dealloc {
    [_repo release];
    [super dealloc];
}

- (void)testFetchCards {
    XCTestExpectation *expectation = [XCTestExpectation new];
    
    [self.repo fetchCardsAtRegion:BlizzardAPIRegionHostKR
                      withOptions:@{BlizzardHSAPILocaleKey: NSStringFromLocale(BlizzardHSAPILocaleKoKR)}
                completionHandler:^(NSArray *arr, NSError *err) {
        NSLog(@"%@", arr);
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
