//
//  PickerViewModel.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 2/19/22.
//

#import "PickerViewModel.h"
#import "UICollectionViewDiffableDataSource+applySnapshotAndWait.h"
#import "NSDiffableDataSourceSnapshot+sort.h"

@interface PickerViewModel ()
@property (retain) NSOperationQueue *queue;
@end

@implementation PickerViewModel

- (instancetype)initWithDataSource:(PickerDataSource *)dataSource {
    self = [self init];
    
    if (self) {
        [self->_dataSource release];
        self->_dataSource = [dataSource retain];
        
        NSOperationQueue *queue = [NSOperationQueue new];
        queue.qualityOfService = NSQualityOfServiceUserInitiated;
        self.queue = queue;
        [queue release];
        
        self.allowsMultipleSelection = NO;
        self.comparator = nil;
    }
    
    return self;
}

- (void)dealloc {
    [_dataSource release];
    [_comparator release];
    [_queue release];
    [super dealloc];
}

- (void)updateDataSourceWithItems:(NSDictionary<PickerSectionModel *, NSSet<PickerItemModel *> *> *)items {
    [self.queue addBarrierBlock:^{
        NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
        [snapshot deleteAllItems];
        
        //
        
        [items enumerateKeysAndObjectsUsingBlock:^(PickerSectionModel * _Nonnull key, NSSet<PickerItemModel *> * _Nonnull obj, BOOL * _Nonnull stop) {
            [snapshot appendSectionsWithIdentifiers:@[key]];
            [snapshot appendItemsWithIdentifiers:obj.allObjects intoSectionWithIdentifier:key];
        }];
        
        [snapshot sortSectionsUsingComparator:^NSComparisonResult(PickerSectionModel * _Nonnull obj1, PickerSectionModel * _Nonnull obj2) {
            return [obj1 compare:obj2];
        }];
        
        [snapshot sortItemsWithSectionIdentifiers:snapshot.sectionIdentifiers usingComparator:^NSComparisonResult(PickerItemModel * _Nonnull obj1, PickerItemModel * _Nonnull obj2) {
            return self.comparator(obj1.key, obj2.key);
        }];
        
        [self.dataSource applySnapshotUsingReloadDataAndWait:snapshot completion:^{}];
        [snapshot release];
    }];
}

- (void)handleSelectionAtIndexPath:(NSIndexPath *)indexPath {
    [self.queue addBarrierBlock:^{
        PickerItemModel * _Nullable itemModel = [self.dataSource itemIdentifierForIndexPath:indexPath];
        if (itemModel == nil) return;
        
        NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
        
        switch (itemModel.type) {
            case PickerItemModelTypeEmpty: {
                if (itemModel.isSelected) {
                    [snapshot release];
                    return;
                }
                
                NSMutableSet<PickerItemModel *> *toBeReconfigured = [NSMutableSet<PickerItemModel *> new];
                
                itemModel.selected = YES;
                [toBeReconfigured addObject:itemModel];
                
                [snapshot.itemIdentifiers enumerateObjectsUsingBlock:^(PickerItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    switch (obj.type) {
                        case PickerItemModelTypeItems: {
                            if (obj.isSelected) {
                                obj.selected = NO;
                                [toBeReconfigured addObject:obj];
                            }
                            break;
                        }
                        default:
                            break;
                    }
                }];
                
                [snapshot reconfigureItemsWithIdentifiers:toBeReconfigured.allObjects];
                [toBeReconfigured release];
                
                break;
            }
            case PickerItemModelTypeItems: {
                if (self.allowsMultipleSelection) {
                    itemModel.selected = !itemModel.isSelected;
                    [snapshot reconfigureItemsWithIdentifiers:@[itemModel]];
                    
                    BOOL __block selectedAnyItems = NO;
                    PickerItemModel * _Nullable __block emptyItemModel = nil;
                    
                    [snapshot.itemIdentifiers enumerateObjectsUsingBlock:^(PickerItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        switch (obj.type) {
                            case PickerItemModelTypeItems: {
                                if (obj.isSelected) {
                                    selectedAnyItems = YES;
                                    *stop = YES;
                                }
                                break;
                            }
                            case PickerItemModelTypeEmpty: {
                                emptyItemModel = obj;
                                break;
                            }
                            default:
                                break;
                        }
                    }];
                    
                    if (emptyItemModel) {
                        if (selectedAnyItems) {
                            if (emptyItemModel.isSelected) {
                                emptyItemModel.selected = NO;
                                [snapshot reconfigureItemsWithIdentifiers:@[emptyItemModel]];
                            }
                        } else {
                            emptyItemModel.selected = YES;
                            [snapshot reconfigureItemsWithIdentifiers:@[emptyItemModel]];
                        }
                    }
                    break;
                } else {
                    NSMutableSet<PickerItemModel *> *toBeReconfigured = [NSMutableSet<PickerItemModel *> new];
                    PickerItemModel * _Nullable __block emptyItemModel = nil;
                    
                    [snapshot.itemIdentifiers enumerateObjectsUsingBlock:^(PickerItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([obj isEqual:itemModel]) return;
                        
                        if (obj.isSelected) {
                            obj.selected = NO;
                            [toBeReconfigured addObject:obj];
                        }
                        
                        switch (obj.type) {
                            case PickerItemModelTypeEmpty: {
                                emptyItemModel = obj;
                                break;
                            }
                            default:
                                break;
                        }
                    }];
                    
                    itemModel.selected = !itemModel.isSelected;
                    [toBeReconfigured addObject:itemModel];
                    
                    if (!itemModel.selected && emptyItemModel) {
                        emptyItemModel.selected = YES;
                        [toBeReconfigured addObject:emptyItemModel];
                    }
                    
                    [snapshot reconfigureItemsWithIdentifiers:toBeReconfigured.allObjects];
                    [toBeReconfigured release];
                }
            }
            default:
                break;
        }
        
        //
        
        [self.dataSource applySnapshotAndWait:snapshot animatingDifferences:YES completion:^{
            [self postEndedLoadingDataSourceFromSnapshot:snapshot];
            [snapshot release];
        }];
    }];
}

- (void)postEndedLoadingDataSourceFromSnapshot:(NSDiffableDataSourceSnapshot *)snapshot {
    [self.queue addOperationWithBlock:^{
        NSMutableSet<PickerItemModel *> *selectedItems = [NSMutableSet<PickerItemModel *> new];
        
        [snapshot.itemIdentifiers enumerateObjectsUsingBlock:^(PickerItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.isSelected) {
                [selectedItems addObject:obj];
            }
        }];
        
        [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNamePickerViewModelEndedLoadingDataSource
                                                          object:self
                                                        userInfo:@{PickerViewModelEndedLoadingDataSourceItemsKey: selectedItems}];
        
        [selectedItems release];
    }];
}

@end
