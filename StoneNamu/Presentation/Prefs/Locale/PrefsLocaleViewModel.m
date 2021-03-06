//
//  PrefsLocaleViewModel.m
//  PrefsLocaleViewModel
//
//  Created by Jinwoo Kim on 8/16/21.
//

#import "PrefsLocaleViewModel.h"
#import <StoneNamuCore/StoneNamuCore.h>
#import "UICollectionViewDiffableDataSource+applySnapshotAndWait.h"
#import "NSDiffableDataSourceSnapshot+sort.h"

@interface PrefsLocaleViewModel ()
@property (retain) NSOperationQueue *queue;
@property (retain) id<PrefsUseCase> prefsUseCase;
@property (retain) id<DataCacheUseCase> dataCacheUseCase;
@property (retain) id<HSMetaDataUseCase> hsMetaDataUseCase;
@end

@implementation PrefsLocaleViewModel

- (instancetype)initWithDataSource:(PrefsLocaleDataSource *)dataSource {
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

- (void)updateLocaleFromIndexPath:(NSIndexPath *)indexPath {
    PrefsLocaleItemModel * _Nullable itemModel = [self.dataSource itemIdentifierForIndexPath:indexPath];
    
    if (itemModel) {
        [self.prefsUseCase fetchWithCompletion:^(Prefs * _Nullable prefs, NSError * _Nullable error) {
            if (prefs) {
                prefs.locale = itemModel.locale;
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
        
        PrefsLocaleSectionModel *sectionModel = [[PrefsLocaleSectionModel alloc] initWithType:PrefsLocaleSectionModelTypeNoName];
        
        [snapshot appendSectionsWithIdentifiers:@[sectionModel]];
        
        //
        
        PrefsLocaleItemModel *itemModel = [[PrefsLocaleItemModel alloc] initWithLocale:nil isSelected:NO];
        [snapshot appendItemsWithIdentifiers:@[itemModel] intoSectionWithIdentifier:sectionModel];
        [itemModel release];
        
        //
        
        for (BlizzardHSAPILocale locale in blizzardHSAPILocales()) {
            PrefsLocaleItemModel *itemModel = [[PrefsLocaleItemModel alloc] initWithLocale:locale isSelected:NO];
            [snapshot appendItemsWithIdentifiers:@[itemModel] intoSectionWithIdentifier:sectionModel];
            [itemModel release];
        }
        
        [sectionModel release];
        
        [snapshot sortItemsWithSectionIdentifiers:snapshot.sectionIdentifiers usingComparator:^NSComparisonResult(PrefsLocaleItemModel * _Nonnull obj1, PrefsLocaleItemModel * _Nonnull obj2) {
            return [obj1.primaryText compare:obj2.primaryText];
        }];
        
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
        
        NSArray<PrefsLocaleItemModel *> *itemModels = snapshot.itemIdentifiers;
        
        for (PrefsLocaleItemModel *itemModel in itemModels) {
            BOOL isSelected = compareNullableValues(prefs.locale, itemModel.locale, @selector(isEqualToString:));
            
            itemModel.isSelected = isSelected;
            [snapshot reconfigureItemsWithIdentifiers:@[itemModel]];
        }
        
        [self.dataSource applySnapshotAndWait:snapshot animatingDifferences:YES completion:^{}];
        [snapshot release];
    }];
}

@end
