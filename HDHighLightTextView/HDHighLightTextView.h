//
//  HDHighLightTextView.h
//  HDHighLightTextView
//
//  Created by Việt Hưng on 2/21/14.
//  Copyright (c) 2014 HDs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HDHighLightTextView;
enum {HDIndexNotFound = NSUIntegerMax};

@protocol HDHighLightTextViewDataSource <NSObject>

@required
- (NSUInteger)numberOfElementsInHighLightTextView:(HDHighLightTextView *)sender;
- (NSRange)highLightTextView:(HDHighLightTextView *)sender rangeOfElementAtIndex:(NSUInteger)index;

- (void)highLightTextView:(HDHighLightTextView *)sender
     didAddElementAtIndex:(NSUInteger)indexElement
                    range:(NSRange)range
                  oldText:(NSString *)oldText
                  newText:(NSString *)newText;

- (void)highLightTextView:(HDHighLightTextView *)sender
     didDeleteElementAtIndex:(NSUInteger)indexElement;

- (void)highLightTextView:(HDHighLightTextView *)sender
  didChangeRangeOfElement:(NSUInteger)indexElement
             fromOldRange:(NSRange)oldRange
               toNewRange:(NSRange)newRange;

@end


@interface HDHighLightTextView : UITextView

@property (nonatomic,weak) IBOutlet id<HDHighLightTextViewDataSource> dataSource;

- (void)resetTypingAttributes;
- (void)replaceNSRange:(NSRange)range withText:(NSString *)text;
- (void)deleteTextElementAtIndex:(NSUInteger)index replacementText:(NSString*)newText;

// this method will call highLightTextView:didAddElementAtIndex:
// if this method caused any changes about range, highLightTextView:didChangeRangeOfElement:fromOldRange:oldRange:toNewRange: will be called
- (void)addNewElementAtRange:(NSRange)range withNewText:(NSString *)newText withSeparatorString:(NSString *)separatorString;
- (NSUInteger)indexElementInRange:(NSRange)range;//return index of first element which is in 'range'
- (NSUInteger)indexElementOfRange:(NSRange)range;//return index of element whose range is 'range'

///// temporary method
// call if 'indexElementInRange:' returns Notfound otherelse crash (need fix later)
- (void)willChangeTextInRange:(NSRange)range withText:(NSString *)string;

@end
