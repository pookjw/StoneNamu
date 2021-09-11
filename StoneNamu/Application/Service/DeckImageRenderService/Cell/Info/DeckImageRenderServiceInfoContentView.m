//
//  DeckImageRenderServiceInfoContentView.m
//  DeckImageRenderServiceInfoContentView
//
//  Created by Jinwoo Kim on 9/11/21.
//

#import "DeckImageRenderServiceInfoContentView.h"
#import "DeckImageRenderServiceInfoContentConfiguration.h"
#import "InsetsLabel.h"

@interface DeckImageRenderServiceInfoContentView ()
@property (retain) InsetsLabel *yearLabel;
@property (retain) InsetsLabel *deckFormatLabel;
@end

@implementation DeckImageRenderServiceInfoContentView

@synthesize configuration;

- (void)dealloc {
    [configuration release];
    [_yearLabel release];
    [_deckFormatLabel release];
    [super dealloc];
}

@end
