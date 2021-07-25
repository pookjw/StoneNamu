//
//  PickerItemView.m
//  PickerItemView
//
//  Created by Jinwoo Kim on 7/26/21.
//

#import "PickerItemView.h"

@interface PickerItemView ()
@property (retain, nonatomic) IBOutlet UIImageView *imageView;
@property (retain, nonatomic) IBOutlet UILabel *primaryLabel;
@property (retain, nonatomic) IBOutlet UILabel *secondaryLabel;
@end

@implementation PickerItemView

- (void)dealloc {
    [_imageView release];
    [_primaryLabel release];
    [_secondaryLabel release];
    [super dealloc];
}

- (void)configureWithImage:(UIImage *)image primaryText:(NSString *)primaryText secondaryText:(NSString *)secondaryText {
    self.imageView.image = image;
    self.primaryLabel.text = primaryText;
    self.secondaryLabel.text = secondaryText;
}

@end
