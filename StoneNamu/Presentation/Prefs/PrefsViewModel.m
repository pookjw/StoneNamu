//
//  PrefsViewModel.m
//  PrefsViewModel
//
//  Created by Jinwoo Kim on 8/14/21.
//

#import "PrefsViewModel.h"
#import "PrefsUseCaseImpl.h"
#import "BlizzardAPIRegionHost.h"
#import "BlizzardHSAPILocale.h"
#import "DataCacheUseCaseImpl.h"
#import "NSSemaphoreCondition.h"

@interface PrefsViewModel ()
@property (retain) NSOperationQueue *queue;
@property (retain) id<PrefsUseCase> prefsUseCase;
@property (retain) id<DataCacheUseCase> dataCacheUseCase;
@end

@implementation PrefsViewModel

- (instancetype)initWithDataSource:(PrefsDataSource *)dataSource {
    self = [self init];
    
    if (self) {
        self.contextMenuIndexPath = nil;
        self->_dataSource = dataSource;
        [dataSource retain];
        
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
    [super dealloc];
}

- (NSString * _Nullable)headerTextFromIndexPath:(NSIndexPath *)indexPath {
    if (@available(iOS 15.0, *)) {
        PrefsSectionModel * _Nullable sectionModel = [self.dataSource sectionIdentifierForIndex:indexPath.section];
        return sectionModel.headerText;
    } else {
        NSArray<PrefsSectionModel *> *sectionModels = self.dataSource.snapshot.sectionIdentifiers;
        
        if (sectionModels.count <= indexPath.section) {
            return nil;
        }
        
        PrefsSectionModel *sectionModel = sectionModels[indexPath.section];
        
        return sectionModel.headerText;
    }
}

- (NSString * _Nullable)footerTextFromIndexPath:(NSIndexPath *)indexPath {
    if (@available(iOS 15.0, *)) {
        PrefsSectionModel * _Nullable sectionModel = [self.dataSource sectionIdentifierForIndex:indexPath.section];
        return sectionModel.footerText;
    } else {
        NSArray<PrefsSectionModel *> *sectionModels = self.dataSource.snapshot.sectionIdentifiers;
        
        if (sectionModels.count <= indexPath.section) {
            return nil;
        }
        
        PrefsSectionModel *sectionModel = sectionModels[indexPath.section];
        
        return sectionModel.footerText;
    }
}

- (void)deleteAllCahces {
    [self.dataCacheUseCase deleteAllDataCaches];
}

- (void)requestDataSource {
    [self.queue addBarrierBlock:^{
        NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
        
        [snapshot deleteAllItems];
        
        //
        
        PrefsSectionModel *searchPrefSection = [[PrefsSectionModel alloc] initWithType:PrefsSectionModelTypeSearchPrefSelection];
        PrefsSectionModel *dataSection = [[PrefsSectionModel alloc] initWithType:PrefsSectionModelTypeData];
        PrefsSectionModel *contributorsSection = [[PrefsSectionModel alloc] initWithType:PrefsSectionModelContributors];
        
        [snapshot appendSectionsWithIdentifiers:@[searchPrefSection, dataSection, contributorsSection]];
        
        //
        
        @autoreleasepool {
            [snapshot appendItemsWithIdentifiers:@[
                [[[PrefsItemModel alloc] initWithType:PrefsItemModelTypeLocaleSelection] autorelease],
                [[[PrefsItemModel alloc] initWithType:PrefsItemModelTypeRegionSelection] autorelease]
            ]
                       intoSectionWithIdentifier:searchPrefSection];
            
            [snapshot appendItemsWithIdentifiers:@[
                [[[PrefsItemModel alloc] initWithType:PrefsItemModelTypeDeleteAllCaches] autorelease]
            ]
                       intoSectionWithIdentifier:dataSection];
            
            [snapshot appendItemsWithIdentifiers:@[
                [[[PrefsItemModel alloc] initWithType:PrefsItemModelTypePookjwContributor] autorelease],
                [[[PrefsItemModel alloc] initWithType:PrefsItemModelTypePnamuContributor] autorelease]
            ]
                       intoSectionWithIdentifier:contributorsSection];
        }
        
        [searchPrefSection release];
        [dataSection release];
        [contributorsSection release];
        
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
            localeItemModel.accessoryText = blizzardHSAPILocalesWithLocalizable()[prefs.locale];
        } else {
            localeItemModel.accessoryText = NSLocalizedString(@"AUTO", @"");
        }
        if (prefs.apiRegionHost) {
            regionItemModel.accessoryText = blizzardHSAPIRegionsForAPIWithLocalizable()[prefs.apiRegionHost];
        } else {
            regionItemModel.accessoryText = NSLocalizedString(@"AUTO", @"");
        }
        
        //
        NSMutableArray *willReloaded = [@[] mutableCopy];
        if (localeItemModel) {
            [willReloaded addObject:localeItemModel];
        }
        if (regionItemModel) {
            [willReloaded addObject:regionItemModel];
        }
        
        if (@available(iOS 15.0, *)) {
            [snapshot reconfigureItemsWithIdentifiers:willReloaded];
        } else {
            [snapshot reloadItemsWithIdentifiers:willReloaded];
        }
        [willReloaded release];
        
        [prefs release];
        
        NSSemaphoreCondition *semaphore = [NSSemaphoreCondition new];
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            [self.dataSource applySnapshot:snapshot animatingDifferences:YES completion:^{
                [semaphore signal];
            }];
            [snapshot release];
        }];
        
        [semaphore wait];
        [semaphore release];
    }];
}

@end
