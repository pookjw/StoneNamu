//
//  PrefsDataViewModel.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/15/21.
//

#import "PrefsDataViewModel.h"
#import <StoneNamuCore/StoneNamuCore.h>

@interface PrefsDataViewModel ()
@property (retain) NSOperationQueue *queue;
@property (retain) id<DataCacheUseCase> dataCacheUseCase;
@end

@implementation PrefsDataViewModel

- (instancetype)init {
    self = [super init];
    
    if (self) {
        NSOperationQueue *queue = [NSOperationQueue new];
        queue.qualityOfService = NSQualityOfServiceUserInitiated;
        self.queue = queue;
        [queue release];
        
        DataCacheUseCaseImpl *dataCacheUseCase = [DataCacheUseCaseImpl new];
        self.dataCacheUseCase = dataCacheUseCase;
        [NSNotificationCenter.defaultCenter addObserver:self
                                               selector:@selector(didChangeDataCache:)
                                                   name:DataCacheUseCaseObserveDataNotificationName
                                                 object:dataCacheUseCase];
        [dataCacheUseCase release];
    }
    
    return self;
}

- (void)dealloc {
    [_queue release];
    [_dataCacheUseCase release];
    [super dealloc];
}

- (void)requestFormattedFileSize {
    [self.dataCacheUseCase fileSizeWithCompletion:^(NSNumber * fileSize) {
        [self postFormattedFileSizeFromFileSize:fileSize];
    }];
}

- (void)didChangeDataCache:(NSNotification *)notification {
    [self.dataCacheUseCase fileSizeWithCompletion:^(NSNumber * fileSize) {
        [self postFormattedFileSizeFromFileSize:fileSize];
    }];
}

- (void)postFormattedFileSizeFromFileSize:(NSNumber *)fileSize {
    [self.queue addBarrierBlock:^{
        NSString *formattedFileSize = [NSByteCountFormatter stringFromByteCount:fileSize.unsignedLongLongValue countStyle:NSByteCountFormatterCountStyleFile];
        
        [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNamePrefsDataViewModelDidChangeFormattedFileSize
                                                          object:self
                                                        userInfo:@{PrefsDataViewModelDidChangeFormattedFileSizeNotificationItemKey: formattedFileSize}];
    }];
}

@end
