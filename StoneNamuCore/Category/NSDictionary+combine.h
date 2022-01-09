//
//  NSDictionary+combine.h
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 1/9/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (combine)
- (NSDictionary *)dictionaryByAddingKey:(id)key value:(id)value;
- (NSDictionary *)dictionaryByCombiningWithDictionary:(NSDictionary *)dictionary;
@end

NS_ASSUME_NONNULL_END
