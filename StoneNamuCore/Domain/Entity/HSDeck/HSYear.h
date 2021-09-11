//
//  HSYear.h
//  HSYear
//
//  Created by Jinwoo Kim on 9/11/21.
//

#import <Foundation/Foundation.h>

typedef NSString * HSYear NS_STRING_ENUM;

static HSYear const HSYearGryphon = @"year-of-the-gryphon";

NSString * hsYearCurrent(void);

NSArray<NSString *> * hsYears(void);
NSDictionary<NSString *, NSString *> *hsYearsWithLocalizables(void);
