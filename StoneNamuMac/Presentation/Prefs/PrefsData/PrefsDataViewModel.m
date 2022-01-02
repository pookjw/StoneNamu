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
@property (retain) id<LocalDeckUseCase> localDeckUseCase;
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
        [NSNotificationCenter.defaultCenter addObserver:self
                                               selector:@selector(didChangeDataCache:)
                                                   name:NSNotificationNameDataCacheUseCaseObserveData
                                                 object:dataCacheUseCase];
        self.dataCacheUseCase = dataCacheUseCase;
        [dataCacheUseCase release];
        
        LocalDeckUseCaseImpl *localDeckUseCase = [LocalDeckUseCaseImpl new];
        self.localDeckUseCase = localDeckUseCase;
        [localDeckUseCase release];
    }
    
    return self;
}

- (void)dealloc {
    [_queue release];
    [_dataCacheUseCase release];
    [_localDeckUseCase release];
    [super dealloc];
}

- (void)requestFormattedFileSize {
    [self.dataCacheUseCase fileSizeWithCompletion:^(NSNumber * fileSize) {
        [self postFormattedFileSizeFromFileSize:fileSize];
    }];
}

- (void)deleteAllCahces {
    [self.dataCacheUseCase deleteAllDataCaches];
}

- (void)deleteAllLocalDecks {
    [self.localDeckUseCase deleteAllLocalDecks];
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
