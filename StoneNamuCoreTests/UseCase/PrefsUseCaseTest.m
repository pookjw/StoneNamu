//
//  PrefsUseCaseTest.m
//  StoneNamuCoreTests
//
//  Created by Jinwoo Kim on 9/20/21.
//

#import <XCTest/XCTest.h>
#import <StoneNamuCore/PrefsUseCaseImpl.h>

@interface PrefsUseCaseTest : XCTestCase
@property (retain) id<PrefsUseCase> _Nullable prefsUseCase;
@end

@implementation PrefsUseCaseTest

- (void)dealloc {
    [_prefsUseCase release];
    [super dealloc];
}

- (void)setUp {
    [super setUp];
    
    PrefsUseCaseImpl *prefsUseCase = [PrefsUseCaseImpl new];
    self.prefsUseCase = prefsUseCase;
    [prefsUseCase release];
}

- (void)tearDown {
    [super tearDown];
    self.prefsUseCase = nil;
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
