//
//  CardBacksViewModel.h
//  StoneNamuWatch WatchKit Extension
//
//  Created by Jinwoo Kim on 3/6/22.
//

#import <Foundation/Foundation.h>
#import "CardBacksSectionModel.h"
#import "CardBacksItemModel.h"

NS_ASSUME_NONNULL_BEGIN

static NSNotificationName const NSNotificationNameCardsViewModelStartedLoadingDataSource = @"NSNotificationNameCardsViewModelStartedLoadingDataSource";
static NSNotificationName const NSNotificationNameCardsViewModelEndedLoadingDataSource = @"NSNotificationNameCardsViewModelEndedLoadingDataSource";

@interface CardBacksViewModel : NSObject
@property (readonly, retain) id dataSource;
@property (readonly, copy) NSDictionary<NSString *, NSSet<NSString *> *> * _Nullable options;
@property (readonly, nonatomic) NSDictionary<NSString *, NSSet<NSString *> *> *defaultOptions;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDataSource:(id)dataSource;
- (BOOL)requestDataSourceWithOptions:(NSDictionary<NSString *, NSSet<NSString *> *> * _Nullable)options reset:(BOOL)reset;
@end

NS_ASSUME_NONNULL_END
