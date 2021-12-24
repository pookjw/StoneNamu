//
//  HSCardSaveImageService.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/22/21.
//

#import "HSCardSaveImageService.h"
#import "PhotosService.h"
#import <StoneNamuResources/StoneNamuResources.h>

@interface HSCardSaveImageService () <NSOpenSavePanelDelegate>
@property (copy) NSSet<HSCard *> *hsCards;
@property (retain) PhotosService *photoService;
@end

@implementation HSCardSaveImageService

- (instancetype)initWithHSCards:(NSSet<HSCard *> *)hsCards {
    self = [self init];
    
    if (self) {
        self.hsCards = hsCards;
        
        NSMutableDictionary<NSString *, NSURL *> *urls = [@{} mutableCopy];
        
        [hsCards enumerateObjectsUsingBlock:^(HSCard * _Nonnull obj, BOOL * _Nonnull stop) {
            urls[obj.name] = obj.image;
        }];
        
        PhotosService *photoService = [[PhotosService alloc] initWithURLs:urls];
        [urls release];
        self.photoService = photoService;
        [photoService release];
    }
    
    return self;
}

- (void)dealloc {
    [_hsCards release];
    [_photoService release];
    [super dealloc];
}

- (void)beginSheetModalForWindow:(NSWindow *)window completion:(HSCardSaveImageServiceSheetCompletion)completion {
    [self.photoService beginSheetModalForWindow:window completion:completion];
}

@end
