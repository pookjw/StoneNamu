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
static NSString * DeckAddCardOptionsViewModelPresentTextFieldOptionTypeItemKey = @"DeckAddCardOptionsViewModelPresentTextFieldOptionTypeItemKey";
static NSString * DeckAddCardOptionsViewModelPresentTextFieldTextItemKey = @"DeckAddCardOptionsViewModelPresentTextFieldTextItemKey";

static NSNotificationName const NSNotificationNameDeckAddCardOptionsViewModelPresentPicker = @"NSNotificationNameDeckAddCardOptionsViewModelPresentPicker";
static NSString * DeckAddCardOptionsViewModelPresentPickerNotificationOptionTypeItemKey = @"DeckAddCardOptionsViewModelPresentPickerNotificationOptionTypeItemKey";
static NSString * DeckAddCardOptionsViewModelPresentPickerNotificationSlugsAndNamesKey = @"DeckAddCardOptionsViewModelPresentPickerNotificationSlugsAndNamesKey";
static NSString * const DeckAddCardOptionsViewModelPresentPickerNotificationValuesItemKey = @"DeckAddCardOptionsViewModelPresentPickerNotificationValuesItemKey";
static NSString * const DeckAddCardOptionsViewModelPresentPickerNotificationShowsEmptyRowItemKey = @"DeckAddCardOptionsViewModelPresentPickerNotificationShowsEmptyRowItemKey";

static NSNotificationName const NSNotificationNameDeckAddCardOptionsViewModelStartedLoadingDataSource = @"NSNotificationNameDeckAddCardOptionsViewModelStartedLoadingDataSource";
static NSNotificationName const NSNotificationNameDeckAddCardOptionsViewModelEndedLoadingDataSource = @"NSNotificationNameDeckAddCardOptionsViewModelEndedLoadingDataSource";

static NSNotificationName const NSNotificationNameDeckAddCardOptionsViewModelErrorOccured = @"NSNotificationNameDeckAddCardOptionsViewModelErrorOccured";
static NSString * const DeckAddCardOptionsViewModelErrorOccuredErrorItemKey = @"DeckAddCardOptionsViewModelErrorOccuredErrorItemKey";

typedef UICollectionViewDiffableDataSource<DeckAddCardOptionSectionModel *, DeckAddCardOptionItemModel *> CardOptionsDataSource;

@interface DeckAddCardOptionsViewModel : NSObject
@property (readonly, retain) CardOptionsDataSource *dataSource;
@property (readonly, nonatomic) NSDictionary<NSString *, NSSet<NSString *> *> *options;
@property (retain) LocalDeck * _Nullable localDeck;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDataSource:(CardOptionsDataSource *)dataSource;
- (void)updateDataSourceWithOptions:(NSDictionary<NSString *, NSSet<NSString *> *> * _Nullable)options;
- (void)handleSelectionForIndexPath:(NSIndexPath *)indexPath;
- (void)updateOptionType:(BlizzardHSAPIOptionType)optionType withValues:(NSSet<NSString *> * _Nullable)values;
@end

NS_ASSUME_NONNULL_END
