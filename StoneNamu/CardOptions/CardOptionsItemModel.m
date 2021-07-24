//
//  CardOptionsItemModel.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import "CardOptionsItemModel.h"

@implementation CardOptionsItemModel

- (instancetype)initWithType:(CardOptionsItemModelType)type {
    self = [self init];
    
    if (self) {
        _type = type;
        self.value = @"";
        [self setAttributes];
    }
    
    return self;
}

- (void)dealloc {
    [_value release];
    [super dealloc];
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[CardOptionsItemModel class]]) {
        return NO;
    }
    
    CardOptionsItemModel *toCompare = (CardOptionsItemModel *)object;
    
    return (self.type == toCompare.type) && ([self.value isEqualToString:toCompare.value]);
}

- (void)setAttributes {
    switch (self.type) {
        case CardOptionsItemModelTypeSet:
            _text = @"확장팩 (번역)";
            _secondaryText = nil;
            break;
        case CardOptionsItemModelTypeClass:
            _text = @"직업 (번역)";
            _secondaryText = nil;
            break;
        case CardOptionsItemModelTypeManaCost:
            _text = @"카드 비용 (번역)";
            _secondaryText = nil;
            break;
        case CardOptionsItemModelTypeAttack:
            _text = @"하수인 공격력 (번역)";
            _secondaryText = nil;
            break;
        case CardOptionsItemModelTypeHealth:
            _text = @"하수인 체력 (번역)";
            _secondaryText = nil;
            break;
        case CardOptionsItemModelTypeCollectible:
            _text = @"수집 가능 (번역)";
            _secondaryText = nil;
            break;
        case CardOptionsItemModelTypeRarity:
            _text = @"카드 등급 (번역)";
            _secondaryText = nil;
            break;
        case CardOptionsItemModelTypeType:
            _text = @"카드 종류 (번역)";
            _secondaryText = nil;
            break;
        case CardOptionsItemModelTypeMinionType:
            _text = @"하수인 종류 (번역)";
            _secondaryText = nil;
            break;
        case CardOptionsItemModelTypeKeyword:
            _text = @"카드 키워드 (번역)";
            _secondaryText = @"예사: 죽음의 메아리, 전투의 함성... (번역)";
            break;
        case CardOptionsItemModelTypeTextFilter:
            _text = @"카드 텍스트 (번역)";
            _secondaryText = nil;
            break;
        case CardOptionsItemModelTypeGameMode:
            _text = @"게임 모드 (번역)";
            _secondaryText = nil;
            break;
        case CardOptionsItemModelTypeSort:
            _text = @"결과 정렬 (번역)";
            _secondaryText = nil;
            break;
        default:
            break;
    }
}

@end
