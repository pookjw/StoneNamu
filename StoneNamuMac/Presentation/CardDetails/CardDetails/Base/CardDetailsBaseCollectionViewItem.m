//
//  CardDetailsBaseCollectionViewItem.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/19/21.
//

#import "CardDetailsBaseCollectionViewItem.h"
#import <StoneNamuResources/StoneNamuResources.h>

@interface CardDetailsBaseCollectionViewItem ()
@property (retain) IBOutlet NSTextField *leadingLabel;
@property (retain) IBOutlet NSTextField *trailingLabel;
@end

@implementation CardDetailsBaseCollectionViewItem

- (void)dealloc {
    [_leadingLabel release];
    [_trailingLabel release];
    [super dealloc];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self clearContents];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self clearContents];
}

- (void)configureWithLeadingText:(NSString *)leadingText trailingText:(NSString *)trailingText {
    self.leadingLabel.stringValue = leadingText;
    
    if ((trailingText == nil) || ([trailingText isEqualToString:@""])) {
        self.trailingLabel.stringValue = [ResourcesService localizationForKey:LocalizableKeyEmpty];
    } else {
        self.trailingLabel.stringValue = trailingText;
    }
}

- (void)clearContents {
    self.leadingLabel.stringValue = @"";
    self.trailingLabel.stringValue = @"";
}

@end
