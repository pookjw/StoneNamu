//
//  DeckImageRenderServiceAboutCollectionViewItem.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 1/3/22.
//

#import "DeckImageRenderServiceAboutCollectionViewItem.h"
#import <StoneNamuResources/StoneNamuResources.h>

@interface DeckImageRenderServiceAboutCollectionViewItem ()
@property (retain) IBOutlet NSTextField *deckYearLabel;
@property (retain) IBOutlet NSTextField *arcaneDustLabel;
@property (retain) IBOutlet NSImageView *arcaneDustImageView;
@end

@implementation DeckImageRenderServiceAboutCollectionViewItem

- (void)dealloc {
    [_deckYearLabel release];
    [_arcaneDustLabel release];
    [_arcaneDustImageView release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAttributes];
}

- (void)configureWithTotalArcaneDust:(NSNumber *)totalArcaneDust hsYearCurrent:(HSYear)hsYearCurrent {
    self.deckYearLabel.stringValue = [ResourcesService localizationForHSYear:hsYearCurrent];
    self.arcaneDustLabel.stringValue = totalArcaneDust.stringWithSepearatedDecimalNumber;
}

- (void)setAttributes {
    self.deckYearLabel.font = [ResourcesService fontForKey:FontKeyGmarketSansTTFMedium size:18.0f];
    self.arcaneDustLabel.font = [ResourcesService fontForKey:FontKeyGmarketSansTTFMedium size:18.0f];
    self.arcaneDustImageView.image = [ResourcesService imageForKey:ImageKeyChemistry];
}

@end
