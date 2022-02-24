//
//  PrefsRegionHostViewModel.m
//  PrefsRegionHostViewModel
//
//  Created by Jinwoo Kim on 8/16/21.
//

#import "PrefsRegionHostViewModel.h"
#import <StoneNamuCore/StoneNamuCore.h>
#import "UICollectionViewDiffableDataSource+applySnapshotAndWait.h"

@interface PrefsRegionHostViewModel ()
@property (retain) NSOperationQueue *queue;
@property (retain) id<PrefsUseCase> prefsUseCase;
@property (retain) id<DataCacheUseCase> dataCacheUseCase;
@property (retain) id<HSMetaDataUseCase> hsMetaDataUseCase;
@end

@implementation PrefsRegionHostViewModel

- (instancetype)initWithDataSource:(PrefsRegionHostDataSource *)dataSource {
    self = [self init];
    
    if (self) {
        [self->_dataSource release];
        self->_dataSource = [dataSource retain];
        
        NSOperationQueue *queue = [NSOperationQueue new];
        queue.qualityOfService = NSQualityOfServiceUserInitiated;
        self.queue = queue;
        [queue release];
        
        PrefsUseCaseImpl *prefsUseCase = [PrefsUseCaseImpl new];
        self.prefsUseCase = prefsUseCase;
        [prefsUseCase release];
        
        DataCacheUseCaseImpl *dataCacheUseCase = [DataCacheUseCaseImpl new];
        self.dataCacheUseCase = dataCacheUseCase;
        [dataCacheUseCase release];
        
        HSMetaDataUseCaseImpl *hsMetaDataUseCase = [HSMetaDataUseCaseImpl new];
        self.hsMetaDataUseCase = hsMetaDataUseCase;
        [hsMetaDataUseCase release];
        
        [self requestDataSource];
    }
    
    return self;
}

- (void)dealloc {
    [_dataSource release];
    [_queue release];
    [_prefsUseCase release];
    [_dataCacheUseCase release];
    [_hsMetaDataUseCase release];
    [super dealloc];
}

- (void)updateRegionHostFromIndexPath:(NSIndexPath *)indexPath {
    PrefsRegionHostItemModel * _Nullable itemModel = [self.dataSource itemIdentifierForIndexPath:indexPath];
    
    if (itemModel) {
        [self.prefsUseCase fetchWithCompletion:^(Prefs * _Nullable prefs, NSError * _Nullable error) {
            if (prefs) {
                prefs.apiRegionHost = itemModel.regionHost;
                [self.prefsUseCase saveChanges];
                [self.hsMetaDataUseCase clearCache];
//                [self.dataCacheUseCase deleteAllDataCaches];
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
        
        [self.dataSource applySnapshotAndWait:snapshot animatingDifferences:YES completion:^{
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
}

- (void)observePrefs {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(prefChangesReceived:)
                                               name:NSNotificationNamePrefsUseCaseObserveData
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
            BOOL isSelected = compareNullableValues(prefs.apiRegionHost, itemModel.regionHost, @selector(isEqualToString:));
            
            itemModel.isSelected = isSelected;
            [snapshot reconfigureItemsWithIdentifiers:@[itemModel]];
        }
        
        [prefs release];
        
        [self.dataSource applySnapshotAndWait:snapshot animatingDifferences:YES completion:^{}];
        [snapshot release];
    }];
}

@end
