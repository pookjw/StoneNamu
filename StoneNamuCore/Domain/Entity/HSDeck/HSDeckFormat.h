//
//  HSDeckFormat.h
//  HSDeckFormat
//
//  Created by Jinwoo Kim on 8/17/21.
//

#import <Foundation/Foundation.h>

typedef NSString * HSDeckFormat NS_STRING_ENUM;

static HSDeckFormat const HSDeckFormatStandard = @"standard";
static HSDeckFormat const HSDeckFormatWild = @"wild";
static HSDeckFormat const HSDeckFormatClassic = @"classic";

NSArray<NSString *> * hsDeckFormats(void);
