//
//  DecksViewModel.m
//  DecksViewModel
//
//  Created by Jinwoo Kim on 8/19/21.
//

#import "DecksViewModel.h"
#import "HSDeckUseCaseImpl.h"
#import "LocalDeckUseCaseImpl.h"
#import "NSDiffableDataSourceSnapshot+sort.h"
#import "UICollectionViewDiffableDataSource+applySnapshotAndWait.h"

@interface DecksViewModel ()
@property (retain) NSOperationQueue *queue;
@property (retain) id<HSDeckUseCase> hsDeckUseCase;
@property (retain) id<LocalDeckUseCase> localDeckUseCase;
@end

@implementation DecksViewModel

- (instancetype)initWithDataSource:(DecksDataSource *)dataSource {
    self = [self init];
    
    if (self) {
        self->_dataSource = [dataSource retain];
        self.contextMenuIndexPath = nil;
        
        NSOperationQueue *queue = [NSOperationQueue new];
        self.queue = queue;
        queue.qualityOfService = NSQualityOfServiceUserInitiated;
        [queue release];
        
        HSDeckUseCaseImpl *hsDeckUseCase = [HSDeckUseCaseImpl new];
        self.hsDeckUseCase = hsDeckUseCase;
        [hsDeckUseCase release];
        
        LocalDeckUseCaseImpl *localDeckUseCase = [LocalDeckUseCaseImpl new];
        self.localDeckUseCase = localDeckUseCase;
        [localDeckUseCase fetchWithCompletion:^(NSArray<LocalDeck *> * _Nullable localDeck, NSError * _Nullable error) {
            [self requestDataSourceWithLocalDecks:localDeck];
        }];
        
        [localDeckUseCase release];
        
        [self startLocalDeckObserving];
    }
    
    return self;
}

- (void)dealloc {
    [_queue release];
    [_dataSource release];
    [_contextMenuIndexPath release];
    [_hsDeckUseCase release];
    [_localDeckUseCase release];
    [super dealloc];
}

- (void)fetchDeckCode:(NSString *)deckCode
                title:(NSString * _Nullable)title
           completion:(DecksViewModelFetchDeckCodeCompletion)completion {
    
    NSString * _Nullable copyTitle = [title copy];
    
    [self.hsDeckUseCase fetchDeckByDeckCode:deckCode completion:^(HSDeck * _Nullable hsDeck, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            completion(nil, nil, error);
            [copyTitle release];
            return;
        }
        
        if (hsDeck) {
            [hsDeck retain];
            [self makeLocalDeckWithHSDeck:hsDeck title:[copyTitle autorelease] completion:^(LocalDeck * _Nonnull localDeck) {
                completion(localDeck, [hsDeck autorelease], error);
            }];
        }
    }];
}

/**
 Use this method to make a new LocalDeck object.
 This method also makes new DecksItemModel into NSDiffableDataSourceSnapshot immediately. It's handy for select cell item on UICollectionView when LocalDeck is created.
 */
- (void)makeLocalDeckWithClass:(HSCardClass)hsCardClass
                    deckFormat:(HSDeckFormat)deckFormat
                    completion:(DecksViewModelMakeLocalDeckCompletion)completion {
    [self.queue addBarrierBlock:^{
        NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
        
        DecksSectionModel * _Nullable sectionModel = nil;
        
        for (DecksSectionModel *tmpSectionModel in snapshot.sectionIdentifiers) {
            if (tmpSectionModel.type == DecksSectionModelTypeNoName) {
                sectionModel = tmpSectionModel;
                break;
            }
        }
        
        if (sectionModel == nil) {
            [snapshot release];
            return;
        }
        
        [self.localDeckUseCase makeLocalDeckWithCompletion:^(LocalDeck * _Nonnull localDeck) {
            [self.queue addBarrierBlock:^{
                localDeck.format = deckFormat;
                localDeck.name = hsCardClassesWithLocalizable()[NSStringFromHSCardClass(hsCardClass)];
                localDeck.classId = [NSNumber numberWithUnsignedInteger:hsCardClass];
                
                DecksItemModel *itemModel = [[DecksItemModel alloc] initWithType:DecksItemModelTypeDeck localDeck:localDeck];
                
                [snapshot appendItemsWithIdentifiers:@[itemModel] intoSectionWithIdentifier:sectionModel];
                [itemModel release];
                [self sortSnapshot:snapshot];
                
                [self.dataSource applySnapshotAndWait:snapshot animatingDifferences:YES completion:^{
                    [snapshot release];
                    [self.localDeckUseCase saveChanges];
                    completion(localDeck);
                }];
            }];
        }];
    }];
}

- (void)makeLocalDeckWithHSDeck:(HSDeck * _Nullable)hsDeck
                          title:(NSString *)title
                     completion:(DecksViewModelMakeLocalDeckCompletion)completion {
    HSDeck * _Nullable copyHSDeck = [hsDeck copy];
    NSString * _Nullable copyTitle = [title copy];
    
    [self.queue addBarrierBlock:^{
        NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
        
        DecksSectionModel * _Nullable sectionModel = nil;
        
        for (DecksSectionModel *tmpSectionModel in snapshot.sectionIdentifiers) {
            if (tmpSectionModel.type == DecksSectionModelTypeNoName) {
                sectionModel = tmpSectionModel;
                break;
            }
        }
        
        if (sectionModel == nil) {
            [snapshot release];
            [copyTitle release];
            return;
        }
        
        [self.localDeckUseCase makeLocalDeckWithCompletion:^(LocalDeck * _Nonnull localDeck) {
            [self.queue addBarrierBlock:^{
                if (copyHSDeck) {
                    [localDeck setValuesAsHSDeck:copyHSDeck];
                }
                
                [copyHSDeck release];
                
                if ((copyTitle != nil) && (![copyTitle isEqualToString:@""])) {
                    localDeck.name = copyTitle;
                }
                [copyTitle release];
                
                DecksItemModel *itemModel = [[DecksItemModel alloc] initWithType:DecksItemModelTypeDeck localDeck:localDeck];
                
                [snapshot appendItemsWithIdentifiers:@[itemModel] intoSectionWithIdentifier:sectionModel];
                [itemModel release];
                [self sortSnapshot:snapshot];
                
                [self.dataSource applySnapshotAndWait:snapshot animatingDifferences:YES completion:^{
                    [snapshot release];
                    [self.localDeckUseCase saveChanges];
                    completion(localDeck);
                }];
            }];
        }];
    }];
}

- (void)deleteLocalDeckFromIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *copyIndexPath = [indexPath copy];
    
    [self.queue addBarrierBlock:^{
        DecksItemModel * _Nullable itemModel = [self.dataSource itemIdentifierForIndexPath:copyIndexPath];
        [copyIndexPath release];
        if (itemModel == nil) return;
        
        switch (itemModel.type) {
            case DecksItemModelTypeDeck:
                [self deleteLocalDeck:itemModel.localDeck];
                break;
            default:
                break;
        }
    }];
}

- (void)deleteLocalDeck:(LocalDeck *)localDeck {
    [localDeck retain];
    
    [self.queue addBarrierBlock:^{
        NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
        
        [snapshot.itemIdentifiers enumerateObjectsUsingBlock:^(DecksItemModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.localDeck isEqual:localDeck]) {
                [snapshot deleteItemsWithIdentifiers:@[obj]];
            }
        }];
        
        [self.dataSource applySnapshotAndWait:snapshot animatingDifferences:YES completion:^{
            [snapshot release];
            
            [self.localDeckUseCase deleteLocalDeck:localDeck];
            [localDeck release];
        }];
    }];
}

- (void)parseClipboardForDeckCodeWithCompletion:(DecksViewModelParseClipboardCompletion)completion {
    [self.queue addOperationWithBlock:^{
        NSString *text = UIPasteboard.generalPasteboard.string;
        
        NSString * __block _Nullable title = nil;
        NSString * __block _Nullable deckCode = nil;
        
        //
        
        for (NSString *tmp in [text componentsSeparatedByString:@"\n"]) {
            if ([tmp hasPrefix:@"###"]) {
                title = [tmp componentsSeparatedByString:@"### "].lastObject;
            } else if ([tmp hasPrefix:@"AA"]) {
                deckCode = tmp;
            }
        }
        
        completion(title, deckCode);
    }];
}

- (NSIndexPath * _Nullable)indexPathForLocalDeck:(LocalDeck *)localDeck {
    for (DecksItemModel *itemModel in self.dataSource.snapshot.itemIdentifiers) {
        if ([itemModel.localDeck isEqual:localDeck]) {
            NSIndexPath *indexPath = [self.dataSource indexPathForItemIdentifier:itemModel];
            return indexPath;
        }
    }
    
    return nil;
}

- (void)requestDataSourceWithLocalDecks:(NSArray<LocalDeck *> *)localDecks {
    [self.queue addBarrierBlock:^{
        NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
        
        [snapshot deleteAllItems];
        
        DecksSectionModel *sectionModel = [[DecksSectionModel alloc] initWithType:DecksSectionModelTypeNoName];
        [snapshot appendSectionsWithIdentifiers:@[sectionModel]];
        
        //
        
        NSMutableArray<DecksItemModel *> *itemModels = [@[] mutableCopy];
        
        for (LocalDeck *localDeck in localDecks) {
            DecksItemModel *itemModel = [[DecksItemModel alloc] initWithType:DecksItemModelTypeDeck localDeck:localDeck];
            [itemModels addObject:itemModel];
            [itemModel release];
        }
        
        [snapshot appendItemsWithIdentifiers:itemModels intoSectionWithIdentifier:sectionModel];
        [itemModels release];
        [sectionModel release];
        
        [self sortSnapshot:snapshot];
        
        //
        
        [self.dataSource applySnapshotAndWait:snapshot animatingDifferences:YES completion:^{
            [snapshot release];
        }];
    }];
}

- (void)sortSnapshot:(NSDiffableDataSourceSnapshot *)snapshot {
    [snapshot sortItemsWithSectionIdentifiers:snapshot.sectionIdentifiers
                              usingComparator:^NSComparisonResult(DecksItemModel *obj1, DecksItemModel *obj2) {
        if ((obj1 == nil) || (obj2 == nil)) {
            return NSOrderedSame;
        }
        return [obj2.localDeck.timestamp compare:obj1.localDeck.timestamp];
    }];
}

- (void)startLocalDeckObserving {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(localDeckChangesReceived:)
                                               name:LocalDeckUseCaseObserveDataNotificationName
                                             object:self.localDeckUseCase];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(localDeckChangesReceived:)
                                               name:LocalDeckUseCaseDeleteAllNotificationName
                                             object:nil];
}

- (void)localDeckChangesReceived:(NSNotification *)notification {
    [self.localDeckUseCase fetchWithCompletion:^(NSArray<LocalDeck *> * _Nullable localDecks, NSError * _Nullable error) {
        [self requestDataSourceWithLocalDecks:localDecks];
    }];
}

@end
