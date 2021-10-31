//
//  NSView+isDarkMode.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 10/31/21.
//

#import "NSView+isDarkMode.h"
#import <StoneNamuCore/StoneNamuCore.h>

@implementation NSView (isDarkMode)

- (BOOL)isDarkMode {
    NSAppearance *effectiveAppearance = self.effectiveAppearance;
    NSAppearanceName name = effectiveAppearance.name;
    
    NSArray<NSAppearanceName> *light = @[
        NSAppearanceNameAqua, NSAppearanceNameVibrantLight, NSAppearanceNameAccessibilityHighContrastAqua, NSAppearanceNameAccessibilityHighContrastVibrantLight
    ];
    
    NSArray<NSAppearanceName> *dark = @[
        NSAppearanceNameDarkAqua, NSAppearanceNameVibrantDark, NSAppearanceNameAccessibilityHighContrastDarkAqua, NSAppearanceNameAccessibilityHighContrastVibrantDark
    ];
    
    if ([light containsString:name]) {
        return NO;
    } else if ([dark containsString:name]) {
        return YES;
    } else {
        return NO;
    }
}

@end
