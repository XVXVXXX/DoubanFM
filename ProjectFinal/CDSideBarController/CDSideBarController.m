//
//  CDSideBarController.m
//  CDSideBar
//
//  Created by Christophe Dellac on 9/11/14.
//  Copyright (c) 2014 Christophe Dellac. All rights reserved.
//

#import "CDSideBarController.h"
static CDSideBarController *sharedInstance;
@implementation CDSideBarController

@synthesize menuColor = _menuColor;
@synthesize isOpen = _isOpen;

#pragma mark - Singleton

+(CDSideBarController *)sharedInstanceWithImages:(NSArray*)images{
    //整个片断在程序运行过程中只执行一遍
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CDSideBarController alloc]initWithImages:images];
    });
    return sharedInstance;
}

+(CDSideBarController *)sharedInstance{
    if (sharedInstance != nil) {
        return sharedInstance;
    }
    return nil;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
        }
    });
    return sharedInstance;
}

#pragma mark - Init

- (CDSideBarController*)initWithImages:(NSArray*)images
{
    _menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _menuButton.bounds = CGRectMake(0, 0, 40, 40);
    [_menuButton setImage:[UIImage imageNamed:@"menuIcon.png"] forState:UIControlStateNormal];
    [_menuButton addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    
    _backgroundMenuView = [[UIView alloc] init];
    _menuColor = [UIColor whiteColor];
    _buttonList = [[NSMutableArray alloc] initWithCapacity:images.count];
    
    int index = 0;
    for (UIImage *image in [images copy])
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:image forState:UIControlStateNormal];
        button.frame = CGRectMake(20, 50 + (80 * index), 50, 50);
        button.tag = index;
        button.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 70, 0);
        [button addTarget:self action:@selector(onMenuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonList addObject:button];
        ++index;
    }
    return self;
}

- (void)insertMenuButtonOnView:(UIView*)view atPosition:(CGPoint)position
{
    _menuButton.frame = CGRectMake(position.x, position.y, _menuButton.bounds.size.width, _menuButton.bounds.size.height);
    [view addSubview:_menuButton];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissMenu)];
    singleTap.cancelsTouchesInView = NO;
    [view addGestureRecognizer:singleTap];
    
    for (UIButton *button in _buttonList)
    {
        [_backgroundMenuView addSubview:button];
    }

    _backgroundMenuView.frame = CGRectMake(view.frame.size.width, 0, 90, view.frame.size.height);
    _backgroundMenuView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5f];
    [view addSubview:_backgroundMenuView];
}

#pragma mark - 
#pragma mark Menu button action

- (void)dismissMenuWithSelection:(UIButton*)button
{
    [UIView animateWithDuration:0.3f
                          delay:0.0f
         usingSpringWithDamping:.2f
          initialSpringVelocity:10.f
                        options:0 animations:^{
                            button.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
                        }
                     completion:^(BOOL finished) {
                         [self dismissMenu];
                     }];
}

- (void)dismissMenu
{
    if (_isOpen)
    {
        _isOpen = !_isOpen;
       [self performDismissAnimation];
    }
}

- (void)showMenu
{
    if (!_isOpen)
    {
        _isOpen = !_isOpen;
        [self performSelectorInBackground:@selector(performOpenAnimation) withObject:nil];
    }
}

- (void)onMenuButtonClick:(UIButton*)button
{
    if ([self.delegate respondsToSelector:@selector(menuButtonClicked:)])
        [self.delegate menuButtonClicked:(int)button.tag];
    [self dismissMenuWithSelection:button];
}

#pragma mark -
#pragma mark - Animations

- (void)performDismissAnimation
{
    [UIView animateWithDuration:0.4f animations:^{
        _menuButton.alpha = 1.0f;
        _menuButton.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
        _backgroundMenuView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        for (UIButton *button in _buttonList) {
            [UIView animateWithDuration:0.4f animations:^{
                button.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 70, 0);
            }];
        }
    });
}

- (void)performOpenAnimation
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.4 animations:^{
            _menuButton.alpha = 0.0f;
            _menuButton.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, -90, 0);
            _backgroundMenuView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, -90, 0);
        }];
    });
    for (UIButton *button in _buttonList)
    {
        [NSThread sleepForTimeInterval:0.02f];
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3f
                                  delay:0.3f
                 usingSpringWithDamping:.7f
                  initialSpringVelocity:10.f
                                options:0
                             animations:^{
                                    button.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
                                }
                             completion:^(BOOL finished) {
                             }];
        });
    }
}

@end

