//
//  DataCacheUseCaseTest.m
//  StoneNamuCoreTests
//
//  Created by Jinwoo Kim on 9/20/21.
//

#import <XCTest/XCTest.h>
#import <StoneNamuCore/DataCacheUseCaseImpl.h>

@interface DataCacheUseCaseTest : XCTestCase
@property (retain) id<DataCacheUseCase> _Nullable dataCacheUseCase;
@end

@implementation DataCacheUseCaseTest

- (void)setUp {
    [super setUp];
    
    DataCacheUseCaseImpl *dataCacheUseCase = [DataCacheUseCaseImpl new];
    self.dataCacheUseCase = dataCacheUseCase;
    [dataCacheUseCase release];
}

- (void)tearDown {
    [super tearDown];
    self.dataCacheUseCase = nil;
}

- (void)test {
    XCTestExpectation *expectation = [XCTestExpectation new];
    NSString *testIdentity = [[NSUUID UUID] UUIDString];
    NSString *testString = [[NSUUID UUID] UUIDString];
    NSData *testData = [testString dataUsingEncoding:NSUTF8StringEncoding];
    
    [self.dataCacheUseCase deleteAllDataCaches];
    [self.dataCacheUseCase makeDataCache:testData identity:testIdentity completion:^{
        [self.dataCacheUseCase dataCachesWithIdentity:testIdentity completion:^(NSArray<NSData *> * _Nullable datas, NSError * _Nullable error) {
            XCTAssertNil(error);
            
            [datas enumerateObjectsUsingBlock:^(NSData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *string = [[NSString alloc] initWithData:obj encoding:NSUTF8StringEncoding];
                
                if ([string isEqualToString:testString]) {
                    [expectation fulfill];
                    *stop = YES;
                }
                
                [string release];
            }];
        }];
    }];
    
    XCTWaiterResult result = [XCTWaiter waitForExpectations:@[expectation] timeout:5];
    [expectation release];
    
    if (result != XCTWaiterResultCompleted) {
        XCTFail("error");
    }
}

@end
