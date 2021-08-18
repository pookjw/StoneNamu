//
//  PrefsLocaleViewModel.m
//  PrefsLocaleViewModel
//
//  Created by Jinwoo Kim on 8/16/21.
//

#import "PrefsLocaleViewModel.h"
#import "PrefsUseCaseImpl.h"
#import "BlizzardHSAPILocale.h"
#import "NSSemaphoreCondition.h"

@interface PrefsLocaleViewModel ()
@property (retain) NSOperationQueue *queue;
@property (retain) id<PrefsUseCase> prefsUseCase;
@end

@implementation PrefsLocaleViewModel

- (instancetype)initWithDataSource:(PrefsLocaleDataSource *)dataSource {
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

- (void)updateLocaleFromIndexPath:(NSIndexPath *)indexPath {
    PrefsLocaleItemModel * _Nullable itemModel = [self.dataSource itemIdentifierForIndexPath:indexPath];
    
    if (itemModel) {
        [self.prefsUseCase fetchWithCompletion:^(Prefs * _Nullable prefs, NSError * _Nullable error) {
            if (prefs) {
                prefs.locale = itemModel.locale;
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
        
        NSArray<PrefsLocaleItemModel *> *itemModels = snapshot.itemIdentifiers;
        
        for (PrefsLocaleItemModel *itemModel in itemModels) {
            BOOL isSelected;
            
            if ([prefs.locale isEqualToString:itemModel.locale]) {
                isSelected = YES;
            } else if ((prefs.locale == nil) && (itemModel.locale == nil)) {
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
