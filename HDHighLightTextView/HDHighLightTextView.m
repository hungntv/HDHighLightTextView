//
//  HDHighLightTextView.m
//  HDHighLightTextView
//
//  Created by Việt Hưng on 2/21/14.
//  Copyright (c) 2014 HDs. All rights reserved.
//

#import "HDHighLightTextView.h"

@implementation HDHighLightTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

//return index of first element which need be changed if text in 'range' was changed
//may return new index (index = 'numberOfElementsInHighLightTextView')
- (int)_firstIndexNeedChangeFromRange:(NSRange)range {
    int newIndex = 0;
    for (; newIndex<[self.dataSource numberOfElementsInHighLightTextView:self]; newIndex++) {
        NSRange eRange = [self.dataSource highLightTextView:self rangeOfElementAtIndex:newIndex];
        if (NSIntersectionRange(eRange, range).length > 0) {
            @throw [NSException exceptionWithName:@"New Range of text is incorrect" reason:[NSString stringWithFormat:@"New range%@ intersects range%@ at index %d",NSStringFromRange(range),NSStringFromRange(eRange),newIndex] userInfo:nil];
        }
        if (eRange.location >= range.location) {
            break;
        }
    }
    return newIndex;
}
- (UITextRange *)_textRangeFromRange:(NSRange)range {
    UITextPosition *beginningPos = self.beginningOfDocument;
    UITextPosition *start = [self positionFromPosition:beginningPos offset:range.location];
    UITextPosition *end = [self positionFromPosition:start offset:range.length];
    return [self textRangeFromPosition:start toPosition:end];
}
#pragma mark -
- (void)resetTypingAttributes {
    NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithDictionary:super.typingAttributes];
    [newDic removeObjectForKey:@"NSColor"];
    super.typingAttributes = newDic;
}

- (void)replaceNSRange:(NSRange)range withText:(NSString *)text {
    
}

- (void)deleteTextElementAtIndex:(NSUInteger)index replacementText:(NSString*)newText {
    NSRange r = [self.dataSource highLightTextView:self rangeOfElementAtIndex:index];
    int alpha = newText.length - r.length;
    
    [self replaceRange:[self _textRangeFromRange:r] withText:newText];
    [self.dataSource highLightTextView:self didDeleteElementAtIndex:index];
    
    for (; index < [self.dataSource numberOfElementsInHighLightTextView:self]; index++) {
        NSRange oldR = [self.dataSource highLightTextView:self rangeOfElementAtIndex:index];
        [self.dataSource highLightTextView:self didChangeRangeOfElement:index fromOldRange:oldR toNewRange:NSMakeRange(oldR.location+alpha, oldR.length)];
    }
}

- (void)addNewElementAtRange:(NSRange)range withNewText:(NSString *)newText withSeparatorString:(NSString *)separatorString {
    
    UITextRange *textRange = [self _textRangeFromRange:range];
    
    //find new index
    int newIndex = [self _firstIndexNeedChangeFromRange:range];
    
    //calculate new range
    NSRange newRange = range;
    newRange.length = newText.length;
    int alphaLocation = newRange.length + separatorString.length - range.length;
    
    //change text
    [self replaceRange:textRange withText:[NSString stringWithFormat:@"%@%@",newText?:@"",separatorString?:@""]];
    //call dataSource
    if (alphaLocation) {
        //need change range of some elements
        for (int i = newIndex; i < [self.dataSource numberOfElementsInHighLightTextView:self]; i++) {
            NSRange r = [self.dataSource highLightTextView:self rangeOfElementAtIndex:i];
            [self.dataSource highLightTextView:self
                       didChangeRangeOfElement:i
                                  fromOldRange:r
                                    toNewRange:NSMakeRange(r.location + alphaLocation, r.length)];
        }
    }
    //need add new element
    [self.dataSource highLightTextView:self
                  didAddElementAtIndex:newIndex
                                 range:newRange
                               oldText:[self textInRange:textRange]
                               newText:newText];
    
    //Set color for new Text
    NSMutableAttributedString *attText = [self.attributedText mutableCopy];
    [attText addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:newRange];
    self.attributedText = attText;
    
}

- (NSUInteger)indexElementInRange:(NSRange)range {
    for (int i=0; i<[self.dataSource numberOfElementsInHighLightTextView:self]; i++) {
        NSRange eRange = [self.dataSource highLightTextView:self rangeOfElementAtIndex:i];
        //when 'range'.length=0 must use 'NSLocationInRange' method
        if (NSIntersectionRange(eRange, range).length > 0 || (range.location!=eRange.location && NSLocationInRange(range.location, eRange))) {
            return i;
        }
    }
    return HDIndexNotFound;
}

- (NSUInteger)indexElementOfRange:(NSRange)range {
    for (int i=0; i<[self.dataSource numberOfElementsInHighLightTextView:self]; i++) {
        NSRange eRange = [self.dataSource highLightTextView:self rangeOfElementAtIndex:i];
        if (NSEqualRanges(eRange, range)) {
            return i;
        }
    }
    return HDIndexNotFound;
}

#pragma mark - Temporary method
- (void)willChangeTextInRange:(NSRange)range withText:(NSString *)string {
    int newIndex = [self _firstIndexNeedChangeFromRange:range];
    int alphaLocation = string.length - range.length;
    for (; newIndex < [self.dataSource numberOfElementsInHighLightTextView:self]; newIndex++) {
        NSRange r = [self.dataSource highLightTextView:self rangeOfElementAtIndex:newIndex];
        [self.dataSource highLightTextView:self didChangeRangeOfElement:newIndex fromOldRange:range toNewRange:NSMakeRange(r.location+alphaLocation, r.length)];
    }
}

#pragma mark - Action from Menu
//- (void)cut:(id)sender {
//    
//}
//- (void)delete:(id)sender {
//    
//}
//- (void)paste:(id)sender {
//    
//}

@end
