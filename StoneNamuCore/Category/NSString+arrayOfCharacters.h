//
//  NSString+arrayOfCharacters.h
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 9/20/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (arrayOfCharacters)
@property (readonly, nonatomic) NSArray<NSString *> * arrayOfCharacters;
@end

NS_ASSUME_NONNULL_END
