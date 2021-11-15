//
//  PrefsDataViewModel.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/15/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static NSNotificationName const NSNotificationNamePrefsDataViewModelDidChangeFormattedFileSize = @"NSNotificationNamePrefsDataViewModelDidChangeFormattedFileSize";
static NSString * const PrefsDataViewModelDidChangeFormattedFileSizeNotificationItemKey = @"PrefsDataViewModelDidChangeFormattedFileSizeNotificationItemKey";

@interface PrefsDataViewModel : NSObject
- (void)requestFormattedFileSize;
@end

NS_ASSUME_NONNULL_END
