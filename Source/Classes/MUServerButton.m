// Copyright 2013 The 'Mumble for iOS' Developers. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

#import "MUServerButton.h"
#import <MumbleKit/MKServerPinger.h>

@interface MUServerButton () <MKServerPingerDelegate> {
    NSString        *_displayname;
    NSString        *_hostname;
    NSString        *_port;
    NSString        *_username;

    MKServerPinger  *_pinger;
    NSUInteger       _pingMs;
    NSUInteger       _userCount;
    NSUInteger       _maxUserCount;
}
@end

@implementation MUServerButton

- (id) initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.opaque = NO;
        self.clearsContextBeforeDrawing = YES;
    }
    return self;
}

- (void) setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    [self setNeedsDisplay];
}

- (void) populateFromDisplayName:(NSString *)displayName hostName:(NSString *)hostName port:(NSString *)port {
    _displayname = [displayName copy];

    _port = [port copy];

    _pinger = nil;

    if ([hostName length] > 0) {
        _hostname = [hostName copy];
        _pinger = [[MKServerPinger alloc] initWithHostname:_hostname port:_port];
        [_pinger setDelegate:self];
    } else {
        _hostname = NSLocalizedString(@"(No Server)", nil);
    }
    
    [self setNeedsDisplay];
}

- (void) populateFromFavouriteServer:(MUFavouriteServer *)favServ {
    _displayname = [[favServ displayName] copy];

    _hostname = [[favServ hostName] copy];

    _port = [NSString stringWithFormat:@"%lu", (unsigned long)[favServ port]];

    if ([[favServ userName] length] > 0) {
        _username = [[favServ userName] copy];
    } else {
        _username = [[[NSUserDefaults standardUserDefaults] objectForKey:@"DefaultUserName"] copy];
    }

    _pinger = nil;
    if ([_hostname length] > 0) {
        _pinger = [[MKServerPinger alloc] initWithHostname:_hostname port:_port];
        [_pinger setDelegate:self];
    } else {
        _hostname = NSLocalizedString(@"(No Server)", nil);
    }
    
    [self setNeedsDisplay];
}

- (void) serverPingerResult:(MKServerPingerResult *)result {
    _pingMs = (NSUInteger)(result->ping * 1000.0f);
    _userCount = (NSUInteger)(result->cur_users);
    _maxUserCount = (NSUInteger)(result->max_users);

    [self setNeedsDisplay];
}

// Drawing code generated by 'Resources/UIElements/MUServerButton/MUServerButton.pcvd'
// and manually hand-tuned to switch gradients.
- (void) drawRect:(CGRect)rect {
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* clearStrokeColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0];
    UIColor* blackShadowColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
    UIColor* greenStart = [UIColor colorWithRed: 0.376 green: 0.604 blue: 0.294 alpha: 1];
    UIColor* greenStop = [UIColor colorWithRed: 0.238 green: 0.383 blue: 0.186 alpha: 1];
    UIColor* redStart = [UIColor colorWithRed: 0.82 green: 0.302 blue: 0.329 alpha: 1];
    UIColor* redStop = [UIColor colorWithRed: 0.498 green: 0.16 blue: 0.178 alpha: 1];
    UIColor* yellowStart = [UIColor colorWithRed: 0.949 green: 0.871 blue: 0.412 alpha: 1];
    UIColor* yellowStop = [UIColor colorWithRed: 0.715 green: 0.652 blue: 0.284 alpha: 1];
    UIColor* highlightStart = [UIColor colorWithRed: 0.618 green: 0.598 blue: 0.598 alpha: 1];
    UIColor* highlightStop = [UIColor colorWithRed: 0.389 green: 0.368 blue: 0.368 alpha: 1];
    
    //// Gradient Declarations
    NSArray* gradientColors;
    if (self.highlighted) {
        gradientColors = [NSArray arrayWithObjects:(id)highlightStart.CGColor, (id)highlightStop.CGColor, nil];
    } else if (_pingMs <= 125) {
        gradientColors = [NSArray arrayWithObjects:(id)greenStart.CGColor, (id)greenStop.CGColor, nil];
    } else if (_pingMs > 125 && _pingMs <= 250) {
        gradientColors = [NSArray arrayWithObjects:(id)yellowStart.CGColor, (id)yellowStop.CGColor, nil];
    } else if (_pingMs > 250) {
        gradientColors = [NSArray arrayWithObjects:(id)redStart.CGColor, (id)redStop.CGColor, nil];
    }

    CGFloat gradientLocations[] = {0, 1};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)gradientColors, gradientLocations);
    
    //// Shadow Declarations
    UIColor* shadow2 = blackShadowColor;
    CGSize shadow2Offset = CGSizeMake(0.1, 1.1);
    CGFloat shadow2BlurRadius = 2;
    UIColor* textShadow = blackShadowColor;
    CGSize textShadowOffset = CGSizeMake(0.1, 1.1);
    CGFloat textShadowBlurRadius = 1;
    
    //// Frames
    CGRect frame = CGRectMake(0, 0, 232, 143);
    
    
    //// Abstracted Attributes
    NSString* titleTextContent = _displayname;
    NSString* pingTextContent = @"∞ ms";
    if (_pingMs < 999)  {
        pingTextContent = [NSString stringWithFormat:@"%lu ms", (unsigned long)_pingMs];
    }
    
    NSString* userTextContent = [NSString stringWithFormat:@"%lu/%lu ppl", (unsigned long)_userCount, (unsigned long)_maxUserCount];

    // Put address in the username text field if there is no username...
    NSString *usernameTextContent = nil;
    NSString* addressTextContent = nil;
    if (_username == nil) {
       usernameTextContent = [NSString stringWithFormat:@"%@:%@", _hostname, _port];
    } else {
        usernameTextContent = _username;
       addressTextContent = [NSString stringWithFormat:@"%@:%@", _hostname, _port];
    }

    
    //// Rounded Rectangle Drawing
    CGRect roundedRectangleRect = CGRectMake(CGRectGetMinX(frame) + 2.5, CGRectGetMinY(frame) + 1.5, CGRectGetWidth(frame) - 5, CGRectGetHeight(frame) - 5);
    UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: roundedRectangleRect cornerRadius: 16];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadow2Offset, shadow2BlurRadius, shadow2.CGColor);
    CGContextBeginTransparencyLayer(context, NULL);
    [roundedRectanglePath addClip];
    CGContextDrawLinearGradient(context, gradient,
                                CGPointMake(CGRectGetMidX(roundedRectangleRect), CGRectGetMinY(roundedRectangleRect)),
                                CGPointMake(CGRectGetMidX(roundedRectangleRect), CGRectGetMaxY(roundedRectangleRect)),
                                0);
    CGContextEndTransparencyLayer(context);
    CGContextRestoreGState(context);
    
    [clearStrokeColor setStroke];
    roundedRectanglePath.lineWidth = 1;
    [roundedRectanglePath stroke];
    
    
    //// Title Text Drawing
    CGRect titleTextRect = CGRectMake(CGRectGetMinX(frame) + 2, CGRectGetMinY(frame) + 11, CGRectGetWidth(frame) - 4, CGRectGetHeight(frame) - 95);
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, textShadowOffset, textShadowBlurRadius, textShadow.CGColor);
    [[UIColor whiteColor] setFill];
    [titleTextContent drawInRect: titleTextRect withFont: [UIFont systemFontOfSize: 32] lineBreakMode: UILineBreakModeWordWrap alignment: UITextAlignmentCenter];
    CGContextRestoreGState(context);
    
    
    
    //// Ping Text Drawing
    CGRect pingTextRect = CGRectMake(CGRectGetMinX(frame) + 18, CGRectGetMinY(frame) + 103, 108, 27);
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, textShadowOffset, textShadowBlurRadius, textShadow.CGColor);
    [[UIColor whiteColor] setFill];
    [pingTextContent drawInRect: pingTextRect withFont: [UIFont systemFontOfSize: [UIFont buttonFontSize]] lineBreakMode: UILineBreakModeWordWrap alignment: UITextAlignmentLeft];
    CGContextRestoreGState(context);
    
    
    
    //// User Text Drawing
    CGRect userTextRect = CGRectMake(CGRectGetMinX(frame) + 127, CGRectGetMinY(frame) + 103, floor((CGRectGetWidth(frame) - 127) * 0.85714 + 0.5), 27);
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, textShadowOffset, textShadowBlurRadius, textShadow.CGColor);
    [[UIColor whiteColor] setFill];
    [userTextContent drawInRect: userTextRect withFont: [UIFont systemFontOfSize: [UIFont buttonFontSize]] lineBreakMode: UILineBreakModeWordWrap alignment: UITextAlignmentRight];
    CGContextRestoreGState(context);
    
    
    
    //// Address Text Drawing
    CGRect addressTextRect = CGRectMake(CGRectGetMinX(frame) + 2, CGRectGetMinY(frame) + 65, CGRectGetWidth(frame) - 5, CGRectGetHeight(frame) - 126);
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, textShadowOffset, textShadowBlurRadius, textShadow.CGColor);
    [[UIColor whiteColor] setFill];
    [addressTextContent drawInRect: addressTextRect withFont: [UIFont systemFontOfSize: 13] lineBreakMode: UILineBreakModeWordWrap alignment: UITextAlignmentCenter];
    CGContextRestoreGState(context);
    
    
    
    //// Username Text Drawing
    CGRect usernameTextRect = CGRectMake(CGRectGetMinX(frame) + 2, CGRectGetMinY(frame) + 49, CGRectGetWidth(frame) - 5, CGRectGetHeight(frame) - 126);
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, textShadowOffset, textShadowBlurRadius, textShadow.CGColor);
    [[UIColor whiteColor] setFill];
    [usernameTextContent drawInRect: usernameTextRect withFont: [UIFont systemFontOfSize: 13] lineBreakMode: UILineBreakModeWordWrap alignment: UITextAlignmentCenter];
    CGContextRestoreGState(context);
    
    
    
    //// Cleanup
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

@end
