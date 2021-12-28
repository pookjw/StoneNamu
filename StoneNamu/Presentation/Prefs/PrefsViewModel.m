//
//  PrefsViewModel.m
//  PrefsViewModel
//
//  Created by Jinwoo Kim on 8/14/21.
//

#import "PrefsViewModel.h"
#import <StoneNamuCore/StoneNamuCore.h>
#import <StoneNamuResources/StoneNamuResources.h>
#import "UICollectionViewDiffableDataSource+applySnapshotAndWait.h"

@interface PrefsViewModel ()
@property (retain) NSOperationQueue *queue;
@property (retain) id<PrefsUseCase> prefsUseCase;
@property (retain) id<DataCacheUseCase> dataCacheUseCase;
@property (retain) id<LocalDeckUseCase> localDeckUseCase;
@end

@implementation PrefsViewModel

- (instancetype)initWithDataSource:(PrefsDataSource *)dataSource {
    self = [self init];
    
    if (self) {
        self.contextMenuIndexPath = nil;
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
        
        LocalDeckUseCaseImpl *localDeckUseCase = [LocalDeckUseCaseImpl new];
        self.localDeckUseCase = localDeckUseCase;
        [localDeckUseCase release];
        
        [self requestDataSource];
    }
    
    return self;
}

- (void)dealloc {
    [_contextMenuIndexPath release];
    [_dataSource release];
    [_queue release];
    [_prefsUseCase release];
    [_dataCacheUseCase release];
    [_localDeckUseCase release];
    [super dealloc];
}

- (NSString * _Nullable)headerTextFromIndexPath:(NSIndexPath *)indexPath {
    PrefsSectionModel * _Nullable sectionModel = [self.dataSource sectionIdentifierForIndex:indexPath.section];
    return sectionModel.headerText;
}

- (NSString * _Nullable)footerTextFromIndexPath:(NSIndexPath *)indexPath {
    PrefsSectionModel * _Nullable sectionModel = [self.dataSource sectionIdentifierForIndex:indexPath.section];
    return sectionModel.footerText;
}

- (void)deleteAllCahces {
    [self.dataCacheUseCase deleteAllDataCaches];
}

- (void)deleteAllLocalDecks {
    [self.localDeckUseCase deleteAllLocalDecks];
}

- (void)requestDataSource {
    [self.queue addBarrierBlock:^{
        NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
        
        [snapshot deleteAllItems];
        
        //
        
        PrefsSectionModel *searchPrefSection = [[PrefsSectionModel alloc] initWithType:PrefsSectionModelTypeSearchPrefSelection];
        PrefsSectionModel *dataSection = [[PrefsSectionModel alloc] initWithType:PrefsSectionModelTypeData];
        PrefsSectionModel *miscellaneousSection = [[PrefsSectionModel alloc] initWithType:PrefsSectionModelMiscellaneous];
        PrefsSectionModel *contributorsSection = [[PrefsSectionModel alloc] initWithType:PrefsSectionModelContributors];
        
        [snapshot appendSectionsWithIdentifiers:@[searchPrefSection, dataSection, miscellaneousSection, contributorsSection]];
        
        //
        
        @autoreleasepool {
            [snapshot appendItemsWithIdentifiers:@[
                [[[PrefsItemModel alloc] initWithType:PrefsItemModelTypeLocaleSelection] autorelease],
                [[[PrefsItemModel alloc] initWithType:PrefsItemModelTypeRegionSelection] autorelease]
            ]
                       intoSectionWithIdentifier:searchPrefSection];
            
            [snapshot appendItemsWithIdentifiers:@[
                [[[PrefsItemModel alloc] initWithType:PrefsItemModelTypeDeleteAllCaches] autorelease],
#if DEBUG
                [[[PrefsItemModel alloc] initWithType:PrefsItemModelTypeDeleteAllLocalDecks] autorelease]
#endif
            ]
                       intoSectionWithIdentifier:dataSection];
            
            [snapshot appendItemsWithIdentifiers:@[
                [[[PrefsItemModel alloc] initWithType:PrefsItemModelTypeJoinTestFlight] autorelease]
            ]
                       intoSectionWithIdentifier:miscellaneousSection];
            
            [snapshot appendItemsWithIdentifiers:@[
                [[[PrefsItemModel alloc] initWithType:PrefsItemModelTypePookjwContributor] autorelease],
                [[[PrefsItemModel alloc] initWithType:PrefsItemModelTypePnamuContributor] autorelease]
            ]
                       intoSectionWithIdentifier:contributorsSection];
        }
        
        [searchPrefSection release];
        [dataSection release];
        [miscellaneousSection release];
        [contributorsSection release];
        
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
    [self.queue addOperationWithBlock:^{
        NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
        
        PrefsItemModel * _Nullable localeItemModel = nil;
        PrefsItemModel * _Nullable regionItemModel = nil;
        
        for (PrefsItemModel *itemModel in snapshot.itemIdentifiers) {
            if (itemModel.type == PrefsItemModelTypeLocaleSelection) {
                localeItemModel = itemModel;
            } else if (itemModel.type == PrefsItemModelTypeRegionSelection) {
                regionItemModel = itemModel;
            }
            
            if (localeItemModel && regionItemModel) {
                break;
            }
        }
        
        //
        
        if (prefs.locale) {
            localeItemModel.accessoryText = [ResourcesService localizationForBlizzardHSAPILocale:prefs.locale];
        } else {
            localeItemModel.accessoryText = [ResourcesService localizationForKey:LocalizableKeyAuto];
        }
        if (prefs.apiRegionHost) {
            regionItemModel.accessoryText = [ResourcesService localizationForBlizzardAPIRegionHost:BlizzardAPIRegionHostFromNSStringForAPI(prefs.apiRegionHost)];
        } else {
            regionItemModel.accessoryText = [ResourcesService localizationForKey:LocalizableKeyAuto];
        }
        
        //
        NSMutableArray *willReloaded = [@[] mutableCopy];
        if (localeItemModel) {
            [willReloaded addObject:localeItemModel];
        }
        if (regionItemModel) {
            [willReloaded addObject:regionItemModel];
        }
        
        [snapshot reconfigureItemsWithIdentifiers:willReloaded];
        [willReloaded release];
        
        [self.dataSource applySnapshotAndWait:snapshot animatingDifferences:YES completion:^{}];
        [snapshot release];
    }];
}

@end
