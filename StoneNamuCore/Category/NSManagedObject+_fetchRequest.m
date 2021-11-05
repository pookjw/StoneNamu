//
//  NSManagedObject+_fetchRequest.m
//  NSManagedObject+_fetchRequest
//
//  Created by Jinwoo Kim on 8/10/21.
//

#import <StoneNamuCore/NSManagedObject+_fetchRequest.h>

@implementation NSManagedObject (_fetchRequest)

+ (NSFetchRequest *)_fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass(self)];
}

@end
