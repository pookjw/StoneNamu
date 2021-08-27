//
//  DeckBaseContentViewModel.m
//  DeckBaseContentViewModel
//
//  Created by Jinwoo Kim on 8/26/21.
//

#import "DeckBaseContentViewModel.h"
#import "ImageService.h"

@implementation DeckBaseContentViewModel

- (UIImage * _Nullable)portraitImageOfClassId:(HSCardClass)classId {
    return [ImageService.sharedInstance portraitImageOfClassId:classId];
}

@end
