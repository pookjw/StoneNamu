//
//  Identifier.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 10/23/21.
//

#import <Foundation/Foundation.h>
#include <TargetConditionals.h>

#if TARGET_OS_OSX
#define IDENTIFIER @"com.pookjw.StoneNamuMacCore"
#else
#define IDENTIFIER @"com.pookjw.StoneNamuCore"
#endif
