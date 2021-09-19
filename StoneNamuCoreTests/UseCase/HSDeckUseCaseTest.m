//
//  HSDeckUseCaseTest.m
//  StoneNamuCoreTests
//
//  Created by Jinwoo Kim on 9/20/21.
//

#import <XCTest/XCTest.h>
#import "HSDeckUseCaseImpl.h"

@interface HSDeckUseCaseTest : XCTestCase
@property (retain) id<HSDeckUseCase> hsDeckUseCase;
@end

@implementation HSDeckUseCaseTest

- (void)setUp {
    [super setUp];
    
    HSDeckUseCaseImpl *hsDeckUseCase = [HSDeckUseCaseImpl new];
    self.hsDeckUseCase = hsDeckUseCase;
    [hsDeckUseCase release];
}

- (void)tearDown {
    [super tearDown];
    
    [self->_hsDeckUseCase release];
}

- (void)testFetchByDeckCode {
    XCTestExpectation *expectation = [XCTestExpectation new];
    
    [self.hsDeckUseCase fetchDeckByDeckCode:@"AAEBAa0GHuUE9xPDFoO7ArW7Are7Ati7AtHBAt/EAonNAvDPAujQApDTApeHA+aIA/yjA5mpA/KsA5GxA5O6A9fOA/vRA/bWA+LeA/vfA/jjA6iKBMGfBJegBKGgBAAA" completion:^(HSDeck * _Nullable hsDeck, NSError * _Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(hsDeck);
        [expectation fulfill];
    }];
    
    XCTWaiterResult result = [XCTWaiter waitForExpectations:@[expectation] timeout:5];
    [expectation release];
    
    if (result != XCTWaiterResultCompleted) {
        XCTAssert("error!");
    }
}

- (void)testFetchByCardList {
    XCTestExpectation *expectation = [XCTestExpectation new];
    NSArray<NSNumber *> *cardList = @[
        @613,
        @2551,
        @2883,
        @40323,
        @40373,
        @40375,
        @40408,
        @41169,
        @41567,
        @42633,
        @42992,
        @43112,
        @43408,
        @50071,
        @50278,
        @53756,
        @54425,
        @54898,
        @55441,
        @56595,
        @59223,
        @59643,
        @60278,
        @61282,
        @61435,
        @61944,
        @66856,
        @69569,
        @69655,
        @69665
    ];
    
    [self.hsDeckUseCase fetchDeckByCardList:cardList classId:HSCardClassPriest completion:^(HSDeck * _Nullable hsDeck, NSError * _Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(hsDeck);
        [expectation fulfill];
    }];
    
    XCTWaiterResult result = [XCTWaiter waitForExpectations:@[expectation] timeout:5];
    [expectation release];
    
    if (result != XCTWaiterResultCompleted) {
        XCTAssert("error!");
    }
}

@end
