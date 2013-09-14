//
//  NavigationViewController.h
//  REMenuExample
//
//  Created by Roman Efimov on 4/18/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REMenu.h"

@interface NavigationViewController : UINavigationController

@property (strong, nonatomic) REMenu *menu;
@property (strong, nonatomic) REMenu *filtermenu;

- (void)toggleMenu;
- (void)closeMenu;
- (void)toggleFilterMenu;

@end
