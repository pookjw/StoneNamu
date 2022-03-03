//
//  HearthStoneRapidAPI.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 3/4/22.
//

#import <Foundation/Foundation.h>

typedef void (^HearthStoneRapidAPICompletion)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable);

NS_ASSUME_NONNULL_BEGIN

@protocol HearthStoneRapidAPI <NSObject>

- (void)getWithPath:(NSString *)path completionHandler:(HearthStoneRapidAPICompletion)completion;

@end

NS_ASSUME_NONNULL_END
