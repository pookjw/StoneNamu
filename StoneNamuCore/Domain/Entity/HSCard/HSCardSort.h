//
//  HSCardSort.h
//  HSCardSort
//
//  Created by Jinwoo Kim on 7/29/21.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, HSCardSort) {
    HSCardSortManaCostAsc,
    HSCardSortManaCostDesc,
    HSCardSortAttackAsc,
    HSCardSortAttackDesc,
    HSCardSortHealthAsc,
    HSCardSortHealthDesc,
    HSCardSortClassAsc,
    HSCardSortClassDesc,
    HSCardSortGroupByClassAsc,
    HSCardSortGroupByClassDesc,
    HSCardSortNameAsc,
    HSCardSortNameDesc
};

NSString * NSStringFromHSCardSort(HSCardSort);
HSCardSort HSCardSortFromNSString(NSString *);

NSArray<NSString *> *hsCardSorts(void);
