//
//  DeckImageRenderServiceIntroCollectionViewItem.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 1/3/22.
//

#import "DeckImageRenderServiceIntroCollectionViewItem.h"
#import <StoneNamuResources/StoneNamuResources.h>

@interface DeckImageRenderServiceIntroCollectionViewItem ()
@property (retain) IBOutlet NSImageView *heroImageView;
@property (retain) IBOutlet NSBox *backgroundBox;
@property (retain) IBOutlet NSTextField *nameLabel;
@property (retain) IBOutlet NSTextField *classLabel;
@property (retain) IBOutlet NSTextField *deckFormatLabel;
@property (assign) IBOutlet NSView *bottomView;
@end

@implementation DeckImageRenderServiceIntroCollectionViewItem

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAttributes];
}

- (void)dealloc {
    [_heroImageView release];
    [_backgroundBox release];
    [_nameLabel release];
    [_classLabel release];
    [_deckFormatLabel release];
    [super dealloc];
}

- (void)configureWithClassId:(HSCardClass)classId deckName:(NSString *)deckName deckFormat:(HSDeckFormat)deckFormat isEasterEgg:(BOOL)isEasterEgg {
    self.heroImageView.image = [ResourcesService portraitImageForClassId:classId];
    
    self.nameLabel.stringValue = deckName;
    self.classLabel.stringValue = [ResourcesService localizationForHSCardClass:classId];
    self.deckFormatLabel.stringValue = [ResourcesService localizationForHSDeckFormat:deckFormat];
    
    if ([deckFormat isEqualToString:HSDeckFormatStandard]) {
        self.deckFormatLabel.textColor = NSColor.greenColor;
    } else if ([deckFormat isEqualToString:HSDeckFormatWild]) {
        self.deckFormatLabel.textColor = NSColor.orangeColor;
    } else if ([deckFormat isEqualToString:HSDeckFormatClassic]) {
        self.deckFormatLabel.textColor = NSColor.yellowColor;
    }
}

- (void)setAttributes {
    self.nameLabel.font = [ResourcesService fontForKey:FontKeyGmarketSansTTFBold size:18.0f];
    self.classLabel.font = [ResourcesService fontForKey:FontKeyGmarketSansTTFMedium size:18.0f];
    self.deckFormatLabel.font = [ResourcesService fontForKey:FontKeyGmarketSansTTFMedium size:18.0f];
    
    self.nameLabel.wantsLayer = YES;
    self.nameLabel.layer.shadowRadius = 2.0f;
    self.nameLabel.layer.shadowOpacity = 1.0f;
    self.nameLabel.layer.shadowOffset = CGSizeZero;
    self.nameLabel.layer.shadowColor = NSColor.blackColor.CGColor;
    self.nameLabel.layer.masksToBounds = NO;
    
    self.classLabel.wantsLayer = YES;
    self.classLabel.layer.shadowRadius = 2.0f;
    self.classLabel.layer.shadowOpacity = 1.0f;
    self.classLabel.layer.shadowOffset = CGSizeZero;
    self.classLabel.layer.shadowColor = NSColor.blackColor.CGColor;
    self.classLabel.layer.masksToBounds = NO;
    
    self.deckFormatLabel.wantsLayer = YES;
    self.deckFormatLabel.layer.shadowRadius = 2.0f;
    self.deckFormatLabel.layer.shadowOpacity = 1.0f;
    self.deckFormatLabel.layer.shadowOffset = CGSizeZero;
    self.deckFormatLabel.layer.shadowColor = NSColor.blackColor.CGColor;
    self.deckFormatLabel.layer.masksToBounds = NO;
}

@end
