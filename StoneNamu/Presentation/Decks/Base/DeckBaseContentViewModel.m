//
//  DeckBaseContentViewModel.m
//  DeckBaseContentViewModel
//
//  Created by Jinwoo Kim on 8/26/21.
//

#import "DeckBaseContentViewModel.h"
#import "HeroPortraitService.h"

@implementation DeckBaseContentViewModel

- (UIImage * _Nullable)portraitImageOfClassId:(HSCardClass)classId {
    return [HeroPortraitService.sharedInstance portraitImageOfClassId:classId];
}

@end
