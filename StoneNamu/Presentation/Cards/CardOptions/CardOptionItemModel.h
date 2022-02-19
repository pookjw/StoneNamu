//
//  CardOptionItemModel.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import <Foundation/Foundation.h>
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CardOptionItemModel : NSObject
@property (copy) NSSet<NSString *> * _Nullable values;

@property (readonly, copy) BlizzardHSAPIOptionType optionType;

@property (readonly, copy) NSDictionary<NSString *, NSString *> * _Nullable slugsAndNames;
@property (readonly) BOOL showsEmptyRow;
@property (readonly) BOOL allowsMultipleSelection;
@property (readonly, copy, nullable) NSComparisonResult (^comparator)(NSString *, NSString *);

@property (readonly, copy) NSString *title;
@property (copy) NSString *accessoryText;
@property (readonly, copy) NSString *toolTip;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithOptionType:(BlizzardHSAPIOptionType)optionType slugsAndNames:(NSDictionary<NSString *, NSString *> * _Nullable)slugsAndNames showsEmptyRow:(BOOL)showsEmptyRow allowsMultipleSelection:(BOOL)allowsMultipleSelection comparator:(NSComparisonResult (^ _Nullable)(NSString *, NSString *))comparator title:(NSString *)title accessoryText:(NSString * _Nullable)accessoryText toolTip:(NSString *)toolTip;
@end

NS_ASSUME_NONNULL_END
