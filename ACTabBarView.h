//
//  ACTabBarView.h
//  iPadMagazine
//
//  Created by Francisco Gindre on 1/17/11.
//  Copyright 2011 AppCrafter.biz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ACTabBarViewDelegate;
@class ACTabBarItem;
@interface ACTabBarView : UIView {
	
	UIImageView *imageView;
	NSMutableArray *items;
	@private
	UIImage *_portraitImage;
	UIImage *_landscapeImage;
	NSInteger _selectedItem;
    
    
}
@property (nonatomic,strong,setter = setLeftACTabBarViewButton:) UIButton *leftACTabBarViewButton;
@property (nonatomic,strong,setter = setRightACTabBarViewButton:) UIButton *rightACTabBarViewButton;
@property (nonatomic,strong)	NSMutableArray *items;
@property (nonatomic,weak) id<ACTabBarViewDelegate> delegate;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,readonly, getter=getSelectedIndex) NSInteger selectedIndex; // -1 if no item is selected


-(id)initWithFrame:(CGRect)frame texture:(UIImage*)texture;
// inits the tab bar with the background images
-(id)initWithbackGroundImage:(UIImage *)portrait landscape:(UIImage*)landcape;
// called when the user selects one of the tabs
-(void)userSelectedIndex:(NSInteger)index;
// called to center the items on the view's frame
-(void)centerItemsOnRect:(CGRect)rect;
// change the selected item programatically
-(void)setSelectedItem:(NSInteger)index ;//calls userSelectedIndex:
// change a tab bar item
-(void)setTabBarItem:(ACTabBarItem*)item atIndex:(NSInteger)index;

-(NSInteger)getSelectedIndex;

-(void)deselectAllTabs;

// deselects the tab and releases it's view controller
-(void)deselectTab:(NSInteger)tab;
@end

@protocol ACTabBarViewDelegate <NSObject>

-(void) tabBar:(ACTabBarView*)tabBar selectedTabItem:(ACTabBarItem*)tabItem;

@end
