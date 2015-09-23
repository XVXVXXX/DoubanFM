//
//  CDSideBarController.h
//  CDSideBar
//
//  Created by Christophe Dellac on 9/11/14.
//  Copyright (c) 2014 Christophe Dellac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol CDSideBarControllerDelegate <NSObject>

- (void)menuButtonClicked:(int)index;

@end

@interface CDSideBarController : NSObject
{
    UIView              *_backgroundMenuView;
    UIButton            *_menuButton;
    NSMutableArray      *_buttonList;
}


@property (nonatomic, retain) UIColor *menuColor;
@property (nonatomic) BOOL isOpen;

@property (nonatomic, weak) id<CDSideBarControllerDelegate> delegate;
+(CDSideBarController *)sharedInstanceWithImages:(NSArray*)images;
+(CDSideBarController *)sharedInstance;
- (CDSideBarController*)initWithImages:(NSArray*)buttonList;
- (void)insertMenuButtonOnView:(UIView*)view atPosition:(CGPoint)position;
- (void)dismissMenu;

@end


