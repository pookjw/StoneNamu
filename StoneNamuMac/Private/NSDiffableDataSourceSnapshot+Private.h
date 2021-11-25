//
//  NSDiffableDataSourceSnapshot+Private.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 11/26/21.
//

#import <Cocoa/Cocoa.h>

@interface NSDiffableDataSourceSnapshot (Private)
- (void)reconfigureItemsWithIdentifiers:(NSArray *)identifiers;
@end
