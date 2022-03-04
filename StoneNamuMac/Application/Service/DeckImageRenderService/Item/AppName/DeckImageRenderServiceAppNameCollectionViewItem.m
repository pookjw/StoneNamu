//
//  DeckImageRenderServiceAppNameCollectionViewItem.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 1/3/22.
//

#import "DeckImageRenderServiceAppNameCollectionViewItem.h"
#import <StoneNamuResources/StoneNamuResources.h>

@interface DeckImageRenderServiceAppNameCollectionViewItem ()
@property (retain) IBOutlet NSTextField *appNameLabel;
@end

@implementation DeckImageRenderServiceAppNameCollectionViewItem

- (void)dealloc {
    [_appNameLabel release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAttributes];
}

- (void)setAttributes {
    self.appNameLabel.font = [ResourcesService fontForKey:FontKeyGmarketSansTTFBold size:18.0f];
    self.appNameLabel.stringValue = [ResourcesService localizationForKey:LocalizableKeyAppName];
    self.appNameLabel.wantsLayer = YES;
    self.appNameLabel.layer.masksToBounds = NO;
}

@end
