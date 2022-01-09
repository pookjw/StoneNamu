//
//  main.m
//  StoneNamuResourcesScript
//
//  Created by Jinwoo Kim on 11/12/21.
//

#import <Foundation/Foundation.h>
#import "NSString+convertToCamelCase.h"

void writeImageKeys(void) {
    NSFileManager *fileManager = [NSFileManager new];
    NSURL *currentDirectoryURL = [NSURL fileURLWithPath:fileManager.currentDirectoryPath isDirectory:YES];
    NSURL *resourcesFrameworkURL = [currentDirectoryURL URLByAppendingPathComponent:@"StoneNamuResources" isDirectory:YES];
    NSURL *assetsURL = [[resourcesFrameworkURL URLByAppendingPathComponent:@"Assets" isDirectory:YES] URLByAppendingPathExtension:@"xcassets"];
    NSURL *imageKeyURL = [[resourcesFrameworkURL URLByAppendingPathComponent:@"ImageKey" isDirectory:NO] URLByAppendingPathExtension:@"h"];
    
    if (![fileManager fileExistsAtPath:resourcesFrameworkURL.path]) {
        [NSException raise:@"StoneNamuResources was not found." format:@"Please check current directory."];
    }
    
    if (![fileManager fileExistsAtPath:assetsURL.path]) {
        [NSException raise:@"StoneNamuResources/Assets.xcassets was not found." format:@"Folder is missing."];
    }
    
    //
    
    NSError * _Nullable error = nil;
    
    NSArray<NSString *> *contents = [fileManager subpathsOfDirectoryAtPath:assetsURL.path error:&error];
    
    if (error) {
        [NSException raise:@"An error occured. (1)" format:@"%@", error.localizedDescription];
    }
    
    NSMutableArray<NSString *> *allKeys = [@[] mutableCopy];
    
    [contents enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSURL *url = [NSURL URLWithString:obj];
        
        if ([url.pathExtension isEqualToString:@"imageset"]) {
            [allKeys addObject:[url URLByDeletingPathExtension].lastPathComponent];
        }
    }];
    
    //
    
    NSMutableString *result = [[NSMutableString alloc] initWithString:@""];
    
    [result appendString:@"#import <Foundation/Foundation.h>\n\n"];
    [result appendString:@"typedef NSString * ImageKey NS_STRING_ENUM;\n\n"];
    
    [allKeys enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [result appendString:[NSString stringWithFormat:@"static ImageKey const ImageKey%@ = @\"%@\";\n", [obj convertToCamelCase], obj]];
    }];
    
    //
    
    if ([fileManager fileExistsAtPath:imageKeyURL.path]) {
        NSError * _Nullable error = nil;
        
        [fileManager removeItemAtURL:imageKeyURL error:&error];
        
        if (error) {
            [NSException raise:@"An error occured. (2)" format:@"%@", error.localizedDescription];
        }
    }
    
    NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
    [result release];
    
    [data writeToURL:imageKeyURL options:0 error:&error];
    
    if (error) {
        [NSException raise:@"An error occured. (3)" format:@"%@", error.localizedDescription];
    }
    
    [fileManager release];
    [allKeys release];
}

void writeLocalizableKeys(void) {
    NSFileManager *fileManager = [NSFileManager new];
    NSURL *currentDirectoryURL = [NSURL fileURLWithPath:fileManager.currentDirectoryPath isDirectory:YES];
    NSURL *resourcesFrameworkURL = [currentDirectoryURL URLByAppendingPathComponent:@"StoneNamuResources" isDirectory:YES];
    NSURL *localizableStringsURL = [[[[resourcesFrameworkURL URLByAppendingPathComponent:@"Localizables" isDirectory:YES] URLByAppendingPathComponent:@"en.lproj" isDirectory:YES] URLByAppendingPathComponent:@"Localizable" isDirectory:NO] URLByAppendingPathExtension:@"strings"];
    NSURL *localizableKeyURL = [[resourcesFrameworkURL URLByAppendingPathComponent:@"LocalizableKey" isDirectory:NO] URLByAppendingPathExtension:@"h"];
    
    if (![fileManager fileExistsAtPath:resourcesFrameworkURL.path]) {
        [NSException raise:@"StoneNamuResources was not found." format:@"Please check current directory."];
    }
    
    if (![fileManager fileExistsAtPath:localizableStringsURL.path]) {
        [NSException raise:@"StoneNamuResources/en.lproj/Localizable.strings was not found." format:@"File is missing."];
    }
    
    //
    
    NSDictionary<NSString *, NSString *> *localizables = [NSDictionary dictionaryWithContentsOfURL:localizableStringsURL];
    NSArray<NSString *> *allKeys = localizables.allKeys;
    
    //
    
    NSMutableString *result = [[NSMutableString alloc] initWithString:@""];
    
    [result appendString:@"#import <Foundation/Foundation.h>\n\n"];
    [result appendString:@"typedef NSString * LocalizableKey NS_STRING_ENUM;\n\n"];
    
    [allKeys enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [result appendString:[NSString stringWithFormat:@"static LocalizableKey const LocalizableKey%@ = @\"%@\";\n", [obj convertToCamelCase], obj]];
    }];
    
    //
    
    if ([fileManager fileExistsAtPath:localizableKeyURL.path]) {
        NSError * _Nullable error = nil;
        
        [fileManager removeItemAtURL:localizableKeyURL error:&error];
        
        if (error) {
            [NSException raise:@"An error occured. (4)" format:@"%@", error.localizedDescription];
        }
    }
    
    NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
    [result release];
    
    NSError * _Nullable error = nil;
    
    [data writeToURL:localizableKeyURL options:0 error:&error];
    
    if (error) {
        [NSException raise:@"An error occured. (5)" format:@"%@", error.localizedDescription];
    }
    
    [fileManager release];
}

void writeFontKeys(void) {
    NSFileManager *fileManager = [NSFileManager new];
    NSURL *currentDirectoryURL = [NSURL fileURLWithPath:fileManager.currentDirectoryPath isDirectory:YES];
    NSURL *resourcesFrameworkURL = [currentDirectoryURL URLByAppendingPathComponent:@"StoneNamuResources" isDirectory:YES];
    NSURL *fontsURL = [resourcesFrameworkURL URLByAppendingPathComponent:@"Fonts" isDirectory:YES];
    NSURL *fontKeyURL = [[resourcesFrameworkURL URLByAppendingPathComponent:@"FontKey" isDirectory:NO] URLByAppendingPathExtension:@"h"];
    
    if (![fileManager fileExistsAtPath:resourcesFrameworkURL.path]) {
        [NSException raise:@"StoneNamuResources was not found." format:@"Please check current directory."];
    }
    
    if (![fileManager fileExistsAtPath:fontsURL.path]) {
        [NSException raise:@"StoneNamuResources/Assets.xcassets was not found." format:@"Folder is missing."];
    }
    
    //
    
    NSError * _Nullable error = nil;
    
    NSArray<NSString *> *contents = [fileManager subpathsOfDirectoryAtPath:fontsURL.path error:&error];
    
    if (error) {
        [NSException raise:@"An error occured. (1)" format:@"%@", error.localizedDescription];
    }
    
    NSMutableArray<NSString *> *allKeys = [@[] mutableCopy];
    
    [contents enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *key = [[[NSURL URLWithString:obj] URLByDeletingPathExtension] lastPathComponent];
        [allKeys addObject:key];
    }];
    
    //
    
    NSMutableString *result = [[NSMutableString alloc] initWithString:@""];
    
    [result appendString:@"#import <Foundation/Foundation.h>\n\n"];
    [result appendString:@"typedef NSString * FontKey NS_STRING_ENUM;\n\n"];
    
    [allKeys enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [result appendString:[NSString stringWithFormat:@"static FontKey const FontKey%@ = @\"%@\";\n", obj, obj]];
    }];
    
    //
    
    if ([fileManager fileExistsAtPath:fontKeyURL.path]) {
        NSError * _Nullable error = nil;
        
        [fileManager removeItemAtURL:fontKeyURL error:&error];
        
        if (error) {
            [NSException raise:@"An error occured. (2)" format:@"%@", error.localizedDescription];
        }
    }
    
    NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
    [result release];
    
    [data writeToURL:fontKeyURL options:0 error:&error];
    
    if (error) {
        [NSException raise:@"An error occured. (3)" format:@"%@", error.localizedDescription];
    }
    
    [fileManager release];
    [allKeys release];
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        writeImageKeys();
        writeLocalizableKeys();
        writeFontKeys();
    }
    return 0;
}
