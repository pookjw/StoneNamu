//
//  PrefsRegionHostViewModel.m
//  PrefsRegionHostViewModel
//
//  Created by Jinwoo Kim on 8/16/21.
//

#import "PrefsRegionHostViewModel.h"
#import "PrefsUseCaseImpl.h"
#import "BlizzardAPIRegionHost.h"
#import "NSSemaphoreCondition.h"

@interface PrefsRegionHostViewModel ()
@property (retain) NSOperationQueue *queue;
@property (retain) id<PrefsUseCase> prefsUseCase;
@end

@implementation PrefsRegionHostViewModel

- (instancetype)initWithDataSource:(PrefsRegionHostDataSource *)dataSource {
    self = [self init];
    
    if (self) {
        self->_dataSource = dataSource;
        [dataSource retain];
        
        NSOperationQueue *queue = [NSOperationQueue new];
        queue.qualityOfService = NSQualityOfServiceUserInitiated;
        self.queue = queue;
        [queue release];
        
        PrefsUseCaseImpl *prefsUseCase = [PrefsUseCaseImpl new];
        self.prefsUseCase = prefsUseCase;
        [prefsUseCase release];
        
        [self requestDataSource];
    }
    
    return self;
}

- (void)dealloc {
    [_dataSource release];
    [_queue release];
    [_prefsUseCase release];
    [super dealloc];
}

- (void)updateRegionHostFromIndexPath:(NSIndexPath *)indexPath {
    PrefsRegionHostItemModel * _Nullable itemModel = [self.dataSource itemIdentifierForIndexPath:indexPath];
    
    if (itemModel) {
        [self.prefsUseCase fetchWithCompletion:^(Prefs * _Nullable prefs, NSError * _Nullable error) {
            if (prefs) {
                prefs.apiRegionHost = itemModel.regionHost;
                [self.prefsUseCase saveChanges];
            }
        }];
    }
}

- (void)requestDataSource {
    [self.queue addBarrierBlock:^{
        NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
        
        [snapshot deleteAllItems];
        
        //
        
        PrefsRegionHostSectionModel *sectionModel = [[PrefsRegionHostSectionModel alloc] initWithType:PrefsRegionSectionModelTypeNoName];
        
        [snapshot appendSectionsWithIdentifiers:@[sectionModel]];
        
        //
        
        PrefsRegionHostItemModel *itemModel = [[PrefsRegionHostItemModel alloc] initWithRegionHost:nil isSelected:NO];
        [snapshot appendItemsWithIdentifiers:@[itemModel] intoSectionWithIdentifier:sectionModel];
        [itemModel release];
        
        //
        
        for (NSString *regionHost in blizzardHSAPIRegionsForAPI()) {
            PrefsRegionHostItemModel *itemModel = [[PrefsRegionHostItemModel alloc] initWithRegionHost:regionHost isSelected:NO];
            [snapshot appendItemsWithIdentifiers:@[itemModel] intoSectionWithIdentifier:sectionModel];
            [itemModel release];
        }
        
        [sectionModel release];
        
        NSSemaphoreCondition *semaphore = [NSSemaphoreCondition new];
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            [self.dataSource applySnapshot:snapshot animatingDifferences:YES completion:^{
                [semaphore signal];
                
                [self.prefsUseCase fetchWithCompletion:^(Prefs * _Nullable prefs, NSError * _Nullable error) {
                    if (prefs) {
                        [self loadPrefs:prefs];
                    }
                }];
                
                [self.queue addBarrierBlock:^{
                    [self observePrefs];
                }];
            }];
            
            [snapshot release];
        }];
        
        [semaphore wait];
        [semaphore release];
    }];
}

- (void)observePrefs {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(prefChangesReceived:)
                                               name:PrefsUseCaseObserveDataNotificationName
                                             object:self.prefsUseCase];
}

- (void)prefChangesReceived:(NSNotification *)notification {
    Prefs * _Nullable prefs = notification.userInfo[PrefsUseCasePrefsNotificationItemKey];
    
    if (prefs) {
        [self loadPrefs:prefs];
    }
}

- (void)loadPrefs:(Prefs *)prefs {
    [prefs retain];
    [self.queue addOperationWithBlock:^{
        
        NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
        
        NSArray<PrefsRegionHostItemModel *> *itemModels = snapshot.itemIdentifiers;
        
        for (PrefsRegionHostItemModel *itemModel in itemModels) {
            BOOL isSelected;
            
            if ([prefs.apiRegionHost isEqualToString:itemModel.regionHost]) {
                isSelected = YES;
            } else if ((prefs.apiRegionHost == nil) && (itemModel.regionHost == nil)) {
                isSelected = YES;
            } else {
                isSelected = NO;
            }
            
            itemModel.isSelected = isSelected;
            
            if (@available(iOS 15.0, *)) {
                [snapshot reconfigureItemsWithIdentifiers:@[itemModel]];
            } else {
                [snapshot reloadItemsWithIdentifiers:@[itemModel]];
            }
        }
        
        [prefs release];
        
        NSSemaphoreCondition *semaphore = [NSSemaphoreCondition new];
        
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            [semaphore signal];
            
            [self.dataSource applySnapshot:snapshot animatingDifferences:YES];
            [snapshot release];
        }];
        
        [semaphore wait];
        [semaphore release];
    }];
}

@end
