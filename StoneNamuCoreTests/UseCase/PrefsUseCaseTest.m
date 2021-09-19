//
//  PrefsUseCaseTest.m
//  StoneNamuCoreTests
//
//  Created by Jinwoo Kim on 9/20/21.
//

#import <XCTest/XCTest.h>
#import "PrefsUseCaseImpl.h"

@interface PrefsUseCaseTest : XCTestCase
@property (retain) id<PrefsUseCase> prefsUseCase;
@end

@implementation PrefsUseCaseTest

- (void)setUp {
    [super setUp];
    
    PrefsUseCaseImpl *prefsUseCase = [PrefsUseCaseImpl new];
    self.prefsUseCase = prefsUseCase;
    [prefsUseCase release];
}

- (void)tearDown {
    [super tearDown];
    
    [self->_prefsUseCase release];
}

- (void)test {
    XCTestExpectation *expectation = [XCTestExpectation new];
    
    [self.prefsUseCase fetchWithCompletion:^(Prefs * _Nullable prefs, NSError * _Nullable error) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    
    XCTWaiterResult result = [XCTWaiter waitForExpectations:@[expectation] timeout:5];
    [expectation release];
    
    if (result != XCTWaiterResultCompleted) {
        XCTFail("error");
    }
}

@end
