//
//  CardBacksViewModel.m
//  StoneNamuWatch WatchKit Extension
//
//  Created by Jinwoo Kim on 3/6/22.
//

#import "CardBacksViewModel.h"
#import "UICollectionViewDiffableDataSource+applySnapshotAndWait.h"

@interface CardBacksViewModel ()
@property (retain) id<HSCardBackUseCase> hsCardBackUseCase;
@property (retain) NSNumber * _Nullable pageCount;
@property (retain) NSNumber *page;
@property (nonatomic, readonly) BOOL canLoadMore;
@property BOOL isFetching;
@property (retain) NSOperationQueue *queue;
@end

@implementation CardBacksViewModel

- (instancetype)initWithDataSource:(id)dataSource {
    self = [self init];
    
    if (self) {
        [self->_dataSource release];
        self->_dataSource = [dataSource retain];
        
        HSCardBackUseCaseImpl *hsCardBackUseCase = [HSCardBackUseCaseImpl new];
        self.hsCardBackUseCase = hsCardBackUseCase;
        [hsCardBackUseCase release];
        
        NSOperationQueue *queue = [NSOperationQueue new];
        queue.qualityOfService = NSQualityOfServiceUserInitiated;
        self.queue = queue;
        [queue release];
        
        self.pageCount = nil;
        self.page = [NSNumber numberWithUnsignedInt:1];
        self.isFetching = NO;
    }
    
    return self;
}

- (void)dealloc {
    [_dataSource release];
    [_options release];
    [_hsCardBackUseCase release];
    [_pageCount release];
    [_page release];
    [_queue release];
    [super dealloc];
}

- (NSDictionary<NSString *, NSSet<NSString *> *> *)defaultOptions {
    return BlizzardHSAPIDefaultOptionsForHSCardBacks();
}

- (BOOL)requestDataSourceWithOptions:(NSDictionary<NSString *, NSSet<NSString *> *> * _Nullable)options reset:(BOOL)reset {
    if (reset) {
        [self resetDataSource];
    } else {
        if (self.isFetching) return NO;
        if (!self.canLoadMore) return NO;
        [self.queue cancelAllOperations];
    }
    
    //
    
    self.isFetching = YES;
    
    NSBlockOperation * __block op = [NSBlockOperation new];
    
    [op addExecutionBlock:^{
        NSDictionary<NSString *, NSSet<NSString *> *> *defaultOptions = self.defaultOptions;
        NSDictionary<NSString *, NSSet<NSString *> *> * _Nullable finalOptions = [options dictionaryByCombiningWithDictionary:defaultOptions shouldOverride:NO];

        if (finalOptions == nil) {
            [self->_options release];
            self->_options = [defaultOptions copy];
        } else {
            [self->_options release];
            self->_options = [finalOptions copy];
        }

        //

        [self postStartedLoadingDataSource];
        
        //
        
        NSMutableDictionary<NSString *, NSSet<NSString *> *> *mutableDic = [self.options mutableCopy];
        
        if (self.pageCount != nil) {
            // Next page
            NSNumber *nextPage = [NSNumber numberWithUnsignedInt:[self.page unsignedIntValue] + 1];
            mutableDic[BlizzardHSAPIOptionTypePage] = [NSSet setWithObject:[nextPage stringValue]];
        } else {
            // Initial data
            mutableDic[BlizzardHSAPIOptionTypePage] = [NSSet setWithObject:[self.page stringValue]];
        }
        
        SemaphoreCondition *semaphore = [[SemaphoreCondition alloc] initWithValue:0];
        
        [self.hsCardBackUseCase fetchWithOptions:mutableDic completionHandler:^(NSArray<HSCardBack *> * _Nullable hsCardBacks, NSNumber * _Nullable pageCount, NSNumber * _Nullable page, NSError * _Nullable error) {
            if (op.isCancelled) {
                [semaphore signal];
                return;
            }
            
            if (error) {
//                [self postError:error];
                [semaphore signal];
                return;
            }
            
            [semaphore signal];
            
            [self updateDataSourceWithHSCardBacks:hsCardBacks completion:^{
                self.pageCount = pageCount;
                self.page = page;
                self.isFetching = NO;
                [self postEndedLoadingDataSource];
            }];
        }];
        
        [mutableDic release];
        [semaphore wait];
        [semaphore release];
    }];
    
    [self.queue addOperation:op];
    [op release];
    
    return YES;
}

- (void)resetDataSource {
    [self.queue cancelAllOperations];
    
    [self.queue addBarrierBlock:^{
        self.pageCount = nil;
        self.page = [NSNumber numberWithUnsignedInt:1];
        NSDiffableDataSourceSnapshot *snapshot = [[self.dataSource snapshot] copy];
        [snapshot deleteAllItems];
        
        [self.dataSource applySnapshotAndWait:snapshot animatingDifferences:NO completion:^{}];
        [snapshot release];
    }];
}

- (BOOL)canLoadMore {
    if (self.pageCount == nil) {
        return YES;
    }
    return ![self.pageCount isEqual:self.page];
}

- (void)updateDataSourceWithHSCardBacks:(NSArray<HSCardBack *> *)hsCardBacks completion:(void (^)(void))completion {
    [self.queue addBarrierBlock:^{
        NSDiffableDataSourceSnapshot *snapshot = [[self.dataSource snapshot] copy];
        
        CardBacksSectionModel * _Nullable __block sectionModel = nil;
        
        [(NSArray *)[snapshot sectionIdentifiers] enumerateObjectsUsingBlock:^(CardBacksSectionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            switch (obj.type) {
                case CardBacksSectionModelTypeCardBacks:
                    sectionModel = [obj retain];
                    *stop = YES;
                    break;
                default:
                    break;
            }
        }];
        
        if (sectionModel == nil) {
            sectionModel = [[CardBacksSectionModel alloc] initWithType:CardBacksSectionModelTypeCardBacks];
            [snapshot appendSectionsWithIdentifiers:@[sectionModel]];
        }
        
        [hsCardBacks enumerateObjectsUsingBlock:^(HSCardBack * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CardBacksItemModel *itemModel = [[CardBacksItemModel alloc] initWithHSCardBack:obj];
            [snapshot appendItemsWithIdentifiers:@[itemModel] intoSectionWithIdentifier:sectionModel];
            [itemModel release];
        }];
        
        [sectionModel release];
        
        [self.dataSource applySnapshotUsingReloadDataAndWait:snapshot completion:completion];
        [snapshot release];
    }];
}

- (void)postStartedLoadingDataSource {
    [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNameCardsViewModelStartedLoadingDataSource
                                                      object:self
                                                    userInfo:nil];
}

- (void)postEndedLoadingDataSource {
    [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNameCardsViewModelEndedLoadingDataSource
                                                      object:self
                                                    userInfo:nil];
}

@end
