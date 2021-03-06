//
//  BattlegroundsCardOptionItemModel.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 2/26/22.
//

#import <Foundation/Foundation.h>
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface BattlegroundsCardOptionItemModel : NSObject
@property (copy) NSSet<NSString *> * _Nullable values;

@property (readonly, copy) BlizzardHSAPIOptionType optionType;

@property (readonly, copy) NSDictionary<NSNumber *, NSDictionary<NSString *, NSString *> *> * _Nullable slugsAndNames;
@property (readonly, copy) NSDictionary<NSNumber *, NSString *> * _Nullable sectionHeaderTexts;
@property (readonly, nonatomic) NSDictionary<NSString *, NSString *> *_Nullable allSlugsAndNames;
@property (readonly) BOOL showsEmptyRow;
@property (readonly) BOOL allowsMultipleSelection;
@property (readonly, copy, nullable) NSComparisonResult (^comparator)(NSString *, NSString *);

@property (readonly, copy) NSString *title;
@property (copy) NSString * _Nullable accessoryText;
@property (readonly, copy) NSString *toolTip;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithOptionType:(BlizzardHSAPIOptionType)optionType slugsAndNames:(NSDictionary<NSNumber *, NSDictionary<NSString *, NSString *> *> * _Nullable)slugsAndNames sectionHeaderTexts:(NSDictionary<NSNumber *, NSString *> * _Nullable)sectionHeaderTexts showsEmptyRow:(BOOL)showsEmptyRow allowsMultipleSelection:(BOOL)allowsMultipleSelection comparator:(NSComparisonResult (^ _Nullable)(NSString *, NSString *))comparator title:(NSString *)title accessoryText:(NSString * _Nullable)accessoryText toolTip:(NSString *)toolTip;
@end

NS_ASSUME_NONNULL_END
