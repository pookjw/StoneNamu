//
//  CardOptionsViewModel.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import "CardOptionsViewModel.h"
#import "BlizzardHSAPIKeys.h"

@interface CardOptionsViewModel ()
@property (retain) NSOperationQueue *queue;
@end

@implementation CardOptionsViewModel

- (instancetype)initWithDataSource:(CardOptionsDataSource *)dataSource {
    self = [self init];
    
    if (self) {
        _dataSource = dataSource;
        [_dataSource retain];
        
        NSOperationQueue *queue = [NSOperationQueue new];
        queue.qualityOfService = NSQualityOfServiceUserInitiated;
        _queue = queue;
        
        [queue addOperationWithBlock:^{
            [self configureSnapshot];
        }];
    }
    
    return self;
}

- (void)dealloc {
    [_dataSource release];
    [_queue release];
    [super dealloc];
}

- (NSDictionary<NSString *,id> *)options {
    NSDiffableDataSourceSnapshot *snapshot = self.dataSource.snapshot;
    NSArray<CardOptionsItemModel *> *itemModels = snapshot.itemIdentifiers;
    
    NSMutableDictionary *dic = [@{} mutableCopy];
    
    for (CardOptionsItemModel *itemModel in itemModels) {
        if ((itemModel.value) && (![itemModel.value isEqualToString:@""])) {
            dic[NSStringFromCardOptionsItemModelType(itemModel.type)] = itemModel.value;
        }
    }
    
    NSDictionary *result = [[dic copy] autorelease];
    [dic release];
    
    return result;
}

- (void)handleSelectionForIndexPath:(NSIndexPath *)indexPath {
    CardOptionsItemModel *itemModel = [self.dataSource itemIdentifierForIndexPath:indexPath];
    
    switch (itemModel.valueSetType) {
        case CardOptionsItemModelValueSetTypeTextField:
            [NSNotificationCenter.defaultCenter postNotificationName:CardOptionsViewModelPresentTextFieldNotificationName
                                                              object:self
                                                            userInfo:@{
                CardOptionsViewModelNotificationItemKey: itemModel
            }];
            break;
        case CardOptionsItemModelValueSetTypePicker:
            [NSNotificationCenter.defaultCenter postNotificationName:CardOptionsViewModelPresentPickerNotificationName
                                                              object:self
                                                            userInfo:@{
                CardOptionsViewModelNotificationItemKey: itemModel,
                CardOptionsViewModelPickerShowEmptyRowNotificationItemKey: [NSNumber numberWithBool:NO]
            }];
            break;
        case CardOptionsItemModelValueSetTypePickerWithEmptyRow:
            [NSNotificationCenter.defaultCenter postNotificationName:CardOptionsViewModelPresentPickerNotificationName
                                                              object:self
                                                            userInfo:@{
                CardOptionsViewModelNotificationItemKey: itemModel,
                CardOptionsViewModelPickerShowEmptyRowNotificationItemKey: [NSNumber numberWithBool:YES]
            }];
            break;
        default:
            break;
    }
}

- (void)updateItem:(CardOptionsItemModel *)itemModel withValue:(NSString * _Nullable)value {
    [itemModel retain];
    [value retain];
    
    [self.queue addOperationWithBlock:^{
        NSDiffableDataSourceSnapshot *snapshot = self.dataSource.snapshot;
        itemModel.value = value;
        [snapshot reconfigureItemsWithIdentifiers:@[itemModel]];
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            [self.dataSource applySnapshot:snapshot animatingDifferences:YES];
        }];
        
        [itemModel release];
        [value release];
    }];
}

- (void)configureSnapshot {
    NSDiffableDataSourceSnapshot *snapshot = self.dataSource.snapshot;
    
    [snapshot deleteAllItems];
    
    CardOptionsSectionModel *cardSectionModel = [[CardOptionsSectionModel alloc] initWithType:CardOptionsSectionModelTypeCard];
    CardOptionsSectionModel *sortSectionModel = [[CardOptionsSectionModel alloc] initWithType:CardOptionsSectionModelTypeSort];
    
    [snapshot appendSectionsWithIdentifiers:@[cardSectionModel, sortSectionModel]];
    
    @autoreleasepool {
        [snapshot appendItemsWithIdentifiers:@[
            [[[CardOptionsItemModel alloc] initWithType:CardOptionsItemModelTypeSet] autorelease],
            [[[CardOptionsItemModel alloc] initWithType:CardOptionsItemModelTypeClass] autorelease],
            [[[CardOptionsItemModel alloc] initWithType:CardOptionsItemModelTypeManaCost] autorelease],
            [[[CardOptionsItemModel alloc] initWithType:CardOptionsItemModelTypeAttack] autorelease],
            [[[CardOptionsItemModel alloc] initWithType:CardOptionsItemModelTypeHealth] autorelease],
            [[[CardOptionsItemModel alloc] initWithType:CardOptionsItemModelTypeCollectible] autorelease],
            [[[CardOptionsItemModel alloc] initWithType:CardOptionsItemModelTypeRarity] autorelease],
            [[[CardOptionsItemModel alloc] initWithType:CardOptionsItemModelTypeType] autorelease],
            [[[CardOptionsItemModel alloc] initWithType:CardOptionsItemModelTypeMinionType] autorelease],
            [[[CardOptionsItemModel alloc] initWithType:CardOptionsItemModelTypeKeyword] autorelease],
            [[[CardOptionsItemModel alloc] initWithType:CardOptionsItemModelTypeTextFilter] autorelease],
            [[[CardOptionsItemModel alloc] initWithType:CardOptionsItemModelTypeGameMode] autorelease]
        ]
                   intoSectionWithIdentifier:cardSectionModel];
        
        [snapshot appendItemsWithIdentifiers:@[
            [[[CardOptionsItemModel alloc] initWithType:CardOptionsItemModelTypeSort] autorelease]
        ]
                   intoSectionWithIdentifier:sortSectionModel];
    }
    
    [cardSectionModel release];
    [sortSectionModel release];
    
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [self.dataSource applySnapshot:snapshot animatingDifferences:YES];
    }];
}

@end
