//
//  DeckAddCardOptionsViewModel.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import "DeckAddCardOptionsViewModel.h"
#import <StoneNamuCore/StoneNamuCore.h>
#import "UICollectionViewDiffableDataSource+applySnapshotAndWait.h"

@interface DeckAddCardOptionsViewModel ()
@property (retain) NSOperationQueue *queue;
@property (retain) id<LocalDeckUseCase> localDeckUseCase;
@end

@implementation DeckAddCardOptionsViewModel

- (instancetype)initWithDataSource:(CardOptionsDataSource *)dataSource {
    self = [self init];
    
    if (self) {
        [self->_dataSource release];
        self->_dataSource = [dataSource retain];
        self.localDeck = nil;
        
        NSOperationQueue *queue = [NSOperationQueue new];
        queue.qualityOfService = NSQualityOfServiceUserInitiated;
        self.queue = queue;
        [queue release];
        
        LocalDeckUseCaseImpl *localDeckUseCase = [LocalDeckUseCaseImpl new];
        self.localDeckUseCase = localDeckUseCase;
        [localDeckUseCase release];
        
        [self configureSnapshot];
        [self startObserving];
    }
    
    return self;
}

- (void)dealloc {
    [_dataSource release];
    [_localDeck release];
    [_queue release];
    [_localDeckUseCase release];
    [super dealloc];
}

- (NSDictionary<NSString *,id> *)options {
    NSDiffableDataSourceSnapshot *snapshot = self.dataSource.snapshot;
    NSArray<DeckAddCardOptionItemModel *> *itemModels = snapshot.itemIdentifiers;
    
    NSMutableDictionary *dic = [@{} mutableCopy];
    
    for (DeckAddCardOptionItemModel *itemModel in itemModels) {
        if ((itemModel.value) && (![itemModel.value isEqualToString:@""])) {
            dic[NSStringFromDeckAddCardOptionItemModelType(itemModel.type)] = itemModel.value;
        }
    }
    
    NSDictionary *result = [[dic copy] autorelease];
    [dic release];
    
    return result;
}

- (void)updateDataSourceWithOptions:(NSDictionary<NSString *,NSString *> * _Nullable)options {
    [self.queue addBarrierBlock:^{
        NSDictionary<NSString *, NSString *> *nonnullOptions;
        
        if (options) {
            nonnullOptions = [options copy];
        } else {
            nonnullOptions = [@{} retain];
        }
        
        //
        
        NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
        NSArray<DeckAddCardOptionItemModel *> *itemModels = snapshot.itemIdentifiers;
        
        for (DeckAddCardOptionItemModel *itemModel in itemModels) {
            NSString *key = NSStringFromDeckAddCardOptionItemModelType(itemModel.type);
            NSString * _Nullable value = nonnullOptions[key];
            itemModel.value = value;
        }
        
        [nonnullOptions release];
        [snapshot reconfigureItemsWithIdentifiers:itemModels];
        
        [self.dataSource applySnapshotAndWait:snapshot animatingDifferences:YES completion:^{}];
        [snapshot release];
    }];
}

- (void)handleSelectionForIndexPath:(NSIndexPath *)indexPath {
    DeckAddCardOptionItemModel *itemModel = [self.dataSource itemIdentifierForIndexPath:indexPath];
    
    switch (itemModel.valueSetType) {
        case DeckAddCardOptionItemModelValueSetTypeTextField:
            [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNameDeckAddCardOptionsViewModelPresentTextField
                                                              object:self
                                                            userInfo:@{
                DeckAddCardOptionsViewModelPresentNotificationItemKey: itemModel
            }];
            break;
        case DeckAddCardOptionItemModelValueSetTypePicker:
            [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNameDeckAddCardOptionsViewModelPresentPicker
                                                              object:self
                                                            userInfo:@{
                DeckAddCardOptionsViewModelPresentNotificationItemKey: itemModel,
                DeckAddCardOptionsViewModelPresentPickerNotificationShowEmptyRowKey: [NSNumber numberWithBool:NO]
            }];
            break;
        case DeckAddCardOptionItemModelValueSetTypePickerWithEmptyRow:
            [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNameDeckAddCardOptionsViewModelPresentPicker
                                                              object:self
                                                            userInfo:@{
                DeckAddCardOptionsViewModelPresentNotificationItemKey: itemModel,
                DeckAddCardOptionsViewModelPresentPickerNotificationShowEmptyRowKey: [NSNumber numberWithBool:YES]
            }];
            break;
        case DeckAddCardOptionItemModelValueSetTypeStepper: {
            [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNameDeckAddCardOptionsViewModelPresentStepper
                                                              object:self
                                                            userInfo:@{
                DeckAddCardOptionsViewModelPresentNotificationItemKey: itemModel
            }];
        }
        default:
            break;
    }
}

- (void)updateItem:(DeckAddCardOptionItemModel *)itemModel withValue:(NSString * _Nullable)value {
    [itemModel retain];
    [value retain];
    
    [self.queue addBarrierBlock:^{
        NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
        itemModel.value = value;
        
        [snapshot reconfigureItemsWithIdentifiers:@[itemModel]];
        
        [itemModel release];
        [value release];
        
        [self.dataSource applySnapshotAndWait:snapshot animatingDifferences:YES completion:^{}];
        [snapshot release];
    }];
}

- (void)configureSnapshot {
    [self.queue addBarrierBlock:^{
        NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
        
        [snapshot deleteAllItems];
        
        DeckAddCardOptionSectionModel *firstSectionModel = [[DeckAddCardOptionSectionModel alloc] initWithType:DeckAddCardOptionSectionModelTypeFirst];
        DeckAddCardOptionSectionModel *secondSectionModel = [[DeckAddCardOptionSectionModel alloc] initWithType:DeckAddCardOptionSectionModelTypeSecond];
        DeckAddCardOptionSectionModel *thirdSectionModel = [[DeckAddCardOptionSectionModel alloc] initWithType:DeckAddCardOptionSectionModelTypeThird];
        DeckAddCardOptionSectionModel *forthSectionModel = [[DeckAddCardOptionSectionModel alloc] initWithType:DeckAddCardOptionSectionModelTypeForth];
        DeckAddCardOptionSectionModel *fifthSectionModel = [[DeckAddCardOptionSectionModel alloc] initWithType:DeckAddCardOptionSectionModelTypeFifth];
        
        [snapshot appendSectionsWithIdentifiers:@[firstSectionModel, secondSectionModel, thirdSectionModel, forthSectionModel, fifthSectionModel]];
        
        @autoreleasepool {
            HSDeckFormat deckFormat = self.localDeck.format;
            HSCardClass classId = self.localDeck.classId.unsignedIntegerValue;
            
            [snapshot appendItemsWithIdentifiers:@[
                [[[DeckAddCardOptionItemModel alloc] initWithType:DeckAddCardOptionItemModelTypeTextFilter deckFormat:deckFormat classId:classId] autorelease]
            ]
                       intoSectionWithIdentifier:firstSectionModel];
            
            [snapshot appendItemsWithIdentifiers:@[
                [[[DeckAddCardOptionItemModel alloc] initWithType:DeckAddCardOptionItemModelTypeSet deckFormat:deckFormat classId:classId] autorelease],
                [[[DeckAddCardOptionItemModel alloc] initWithType:DeckAddCardOptionItemModelTypeClass deckFormat:deckFormat classId:classId] autorelease],
            ]
                       intoSectionWithIdentifier:secondSectionModel];
            
            [snapshot appendItemsWithIdentifiers:@[
                [[[DeckAddCardOptionItemModel alloc] initWithType:DeckAddCardOptionItemModelTypeManaCost deckFormat:deckFormat classId:classId] autorelease],
                [[[DeckAddCardOptionItemModel alloc] initWithType:DeckAddCardOptionItemModelTypeAttack deckFormat:deckFormat classId:classId] autorelease],
                [[[DeckAddCardOptionItemModel alloc] initWithType:DeckAddCardOptionItemModelTypeHealth deckFormat:deckFormat classId:classId] autorelease]
            ]
                       intoSectionWithIdentifier:thirdSectionModel];
            
            [snapshot appendItemsWithIdentifiers:@[
                [[[DeckAddCardOptionItemModel alloc] initWithType:DeckAddCardOptionItemModelTypeCollectible deckFormat:deckFormat classId:classId] autorelease],
                [[[DeckAddCardOptionItemModel alloc] initWithType:DeckAddCardOptionItemModelTypeRarity deckFormat:deckFormat classId:classId] autorelease],
                [[[DeckAddCardOptionItemModel alloc] initWithType:DeckAddCardOptionItemModelTypeType deckFormat:deckFormat classId:classId] autorelease],
                [[[DeckAddCardOptionItemModel alloc] initWithType:DeckAddCardOptionItemModelTypeMinionType deckFormat:deckFormat classId:classId] autorelease],
                [[[DeckAddCardOptionItemModel alloc] initWithType:DeckAddCardOptionItemModelTypeSpellSchool deckFormat:deckFormat classId:classId] autorelease],
                [[[DeckAddCardOptionItemModel alloc] initWithType:DeckAddCardOptionItemModelTypeKeyword deckFormat:deckFormat classId:classId] autorelease],
                [[[DeckAddCardOptionItemModel alloc] initWithType:DeckAddCardOptionItemModelTypeGameMode deckFormat:deckFormat classId:classId] autorelease]
            ]
                       intoSectionWithIdentifier:forthSectionModel];
            
            [snapshot appendItemsWithIdentifiers:@[
                [[[DeckAddCardOptionItemModel alloc] initWithType:DeckAddCardOptionItemModelTypeSort deckFormat:deckFormat classId:classId] autorelease]
            ]
                       intoSectionWithIdentifier:fifthSectionModel];
        }
        
        [firstSectionModel release];
        [secondSectionModel release];
        [thirdSectionModel release];
        [forthSectionModel release];
        [fifthSectionModel release];
        
        [self.dataSource applySnapshotAndWait:snapshot animatingDifferences:YES completion:^{}];
        [snapshot release];
    }];
}

- (void)startObserving {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(localDeckChangesReceived:)
                                               name:NSNotificationNameLocalDeckUseCaseObserveData
                                             object:self.localDeckUseCase];
}

- (void)localDeckChangesReceived:(NSNotification *)notification {
    if (self.localDeck != nil) {
        [self.localDeckUseCase refreshObject:self.localDeck mergeChanges:NO completion:^{
            [self reconfigureDataSourceWhenLocalDeckChanged];
        }];
    }
}

- (void)reconfigureDataSourceWhenLocalDeckChanged {
    [self.queue addBarrierBlock:^{
        NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
        
        [snapshot.itemIdentifiers enumerateObjectsUsingBlock:^(DeckAddCardOptionItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.deckFormat = self.localDeck.format;
            obj.classId = self.localDeck.classId.unsignedIntegerValue;
        }];
        
        [snapshot reconfigureItemsWithIdentifiers:snapshot.itemIdentifiers];
        
        [self.dataSource applySnapshotAndWait:snapshot animatingDifferences:YES completion:^{}];
        [snapshot release];
    }];
}

@end
