//
//  CardDetailsBaseCollectionViewItem.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/19/21.
//

#import "CardDetailsBaseCollectionViewItem.h"
#import "VibrancyTextField.h"
#import "NSString+attributedStringWhenHTML.h"
#import <StoneNamuResources/StoneNamuResources.h>

@interface CardDetailsBaseCollectionViewItem ()
@property (retain) IBOutlet VibrancyTextField *leadingLabel;
@property (retain) IBOutlet VibrancyTextField *trailingLabel;
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
    [self setAttributes];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self clearContents];
}

- (void)configureWithLeadingText:(NSString *)leadingText trailingText:(NSString *)trailingText {
    self.leadingLabel.stringValue = leadingText;
    
    NSString *_trailingText = trailingText.attributedStringWhenHTML.string;
    
    if ((_trailingText == nil) || ([_trailingText isEqualToString:@""])) {
        self.trailingLabel.stringValue = [ResourcesService localizationForKey:LocalizableKeyEmpty];
    } else {
        self.trailingLabel.stringValue = _trailingText;
    }
}

- (void)setAttributes {
    self.leadingLabel.textColor = NSColor.systemGrayColor;
    self.trailingLabel.textColor = NSColor.systemGrayColor;
}

- (void)clearContents {
    self.leadingLabel.stringValue = @"";
    self.trailingLabel.stringValue = @"";
}

@end
