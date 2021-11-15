//
//  DeckAddCardOptionsViewModel.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import <UIKit/UIKit.h>
#import "DeckAddCardOptionSectionModel.h"
#import "DeckAddCardOptionItemModel.h"
#import "PickerItemModel.h"
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

static NSNotificationName const NSNotificationNameDeckAddCardOptionsViewModelPresentTextField = @"NSNotificationNameDeckAddCardOptionsViewModelPresentTextField";
static NSNotificationName const NSNotificationNameDeckAddCardOptionsViewModelPresentPicker = @"NSNotificationNameDeckAddCardOptionsViewModelPresentPicker";
static NSNotificationName const NSNotificationNameDeckAddCardOptionsViewModelPresentStepper = @"NSNotificationNameDeckAddCardOptionsViewModelPresentStepper";
static NSString * const DeckAddCardOptionsViewModelPresentNotificationItemKey = @"DeckAddCardOptionsViewModelPresentNotificationItemKey";
static NSString * const DeckAddCardOptionsViewModelPresentPickerNotificationShowEmptyRowKey = @"DeckAddCardOptionsViewModelPresentPickerNotificationShowEmptyRowKey";

typedef UICollectionViewDiffableDataSource<DeckAddCardOptionSectionModel *, DeckAddCardOptionItemModel *> CardOptionsDataSource;

@interface DeckAddCardOptionsViewModel : NSObject
@property (readonly, retain) CardOptionsDataSource *dataSource;
@property (readonly, nonatomic) NSDictionary<NSString *, NSString *> *options;
@property (retain) LocalDeck * _Nullable localDeck;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDataSource:(CardOptionsDataSource *)dataSource;
- (void)updateDataSourceWithOptions:(NSDictionary<NSString *, NSString *> * _Nullable)options;
- (void)handleSelectionForIndexPath:(NSIndexPath *)indexPath;
- (void)updateItem:(DeckAddCardOptionItemModel *)itemModel withValue:(NSString * _Nullable)value;
@end

NS_ASSUME_NONNULL_END
