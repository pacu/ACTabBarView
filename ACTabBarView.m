//
//  ACTabBarView.m
//  iPadMagazine
//
//  Created by Francisco Gindre on 1/17/11.
//  Copyright 2011 AppCrafter.biz. All rights reserved.
//

#import "ACTabBarView.h"
#import "ACTabBarItem.h"
#import "iPadMagazineAppDelegate.h"
#import "ReaderViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ACTabBarView (private)

-(void) setLeftACTabBarViewButton:(UIButton*)button;
-(void) setRightACTabBarViewButton:(UIButton *)button;


@end
@implementation ACTabBarView
@synthesize items, imageView,delegate, leftACTabBarViewButton,rightACTabBarViewButton;

#define MAX_ITEMS 6

#define kBarButtonWidth 65
#define LEFT_BAR_BUTTON_RECT CGRectMake(0,0,kBarButtonWidth,self.frame.size.height);
#define RIGHT_BAR_BUTTON_RECT_PORTRAIT CGRectMake (SCREEN_WIDTH - kBarButtonWidth, 0, kBarButtonWidth,self.frame.size.height)
#define RIGHT_BAR_BUTTON_RECT_LANDSCAPE CGRectMake (SCREEN_HEIGHT - kBarButtonWidth, 0, kBarButtonWidth,self.frame.size.height)
#define TAB_BAR_AREA_PORTRAIT CGRectMake (kBarButtonWidth,0,SCREEN_WIDTH - (kBarButtonWidth * 2) ,self.frame.size.height)
#define TAB_BAR_AREA_LANDSCAPE CGRectMake (kBarButtonWidth,0,SCREEN_HEIGHT - (kBarButtonWidth * 2 ),self.frame.size.height) 

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame texture:(UIImage*)texture {
  //  self = [self initWithFrame:CGRectMake(0, 955, SCREEN_WIDTH, 49)];
    self = [self initWithFrame:frame];
    if (self) {
        items = [[NSMutableArray alloc] initWithCapacity:MAX_ITEMS];
		self.backgroundColor = [UIColor colorWithPatternImage:texture];
        
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		

    }
    return self;
}
-(id)initWithbackGroundImage:(UIImage *)portrait landscape:(UIImage*)landcape {
	self = [self initWithFrame:CGRectMake(0, 955, SCREEN_WIDTH, 49)];
	if (self) {

		items = [[NSMutableArray alloc] initWithCapacity:MAX_ITEMS];
		_portraitImage = portrait;
		_landscapeImage = landcape;
		imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
		imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		
		[self addSubview:imageView];

	}
#if DEBUG
	NSLog(@"ACTabBarView initWithbackGroundImage: self.frame = %@", NSStringFromCGRect(self.frame));
#endif
	return self;
}

-(void)layoutSubviews {
	
//#ifdef TARGET_IPHONE_SIMULATOR
//	
//	UIDeviceOrientation orientation= [[UIApplication sharedApplication] statusBarOrientation];
//#else
	
//	iPadMagazineAppDelegate *appDelegate = GET_APP_DELEGATE;
    iPadMagazineAppDelegate *appDelegate = GET_APP_DELEGATE;
	UIInterfaceOrientation deviceOrientation = appDelegate.navigationController.interfaceOrientation;
//#endif
#if DEBUG 
	NSLog(@"ACTabBarView layoutSubviews orientation[%d]",deviceOrientation);
#endif
	if (UIInterfaceOrientationIsLandscape(deviceOrientation)){
		
		CGRect rect = self.frame;
		rect.size.width = SCREEN_HEIGHT;
		self.frame = rect;
		[imageView setImage:_landscapeImage];

		if (self.rightACTabBarViewButton) 
            self.rightACTabBarViewButton.frame = RIGHT_BAR_BUTTON_RECT_LANDSCAPE;
		[self centerItemsOnRect:TAB_BAR_AREA_LANDSCAPE];
	}
	if (UIInterfaceOrientationIsPortrait(deviceOrientation)) {
		CGRect rect = self.frame;
		rect.size.width = SCREEN_WIDTH;
		self.frame = rect;
		[imageView setImage:_portraitImage];
        
        if (self.rightACTabBarViewButton) 
            self.rightACTabBarViewButton.frame = RIGHT_BAR_BUTTON_RECT_PORTRAIT;
        
        [self centerItemsOnRect:TAB_BAR_AREA_PORTRAIT];
	}
#if DEBUG
	NSLog(@"ACTabBarView layoutSubviews: self.frame = %@", NSStringFromCGRect(self.frame));
#endif
			
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/
-(void)centerItemsOnRect:(CGRect)rect {
	if ([items count]<1) {
		return;
	}
#if DEBUG 
	NSLog(@"ACTabBarView.m -> centerItemsOnRect:%@",NSStringFromCGRect(rect));
#endif
	// get the total length of the items
	NSInteger totalItemLength = [[items objectAtIndex:0] frame].size.width *[items count];
	// calculate the free space on the rect
	NSInteger freeSpace = rect.size.width - totalItemLength;
	// calculate the free space that should be placed to the left of the items
	NSInteger freeSpaceLeft = freeSpace/2;
	
	for (int i=0; i<[items count]; i++) {
		ACTabBarItem *item =(ACTabBarItem*) [items objectAtIndex:i];
		
#if DEBUG 
		NSLog(@"ACTabBarView.m -> centerItemsOnRect: item:%d %@",i,item);
#endif
		CGRect itemRect = item.frame;
		itemRect.origin.x =rect.origin.x+ freeSpaceLeft + (i* itemRect.size.width);
		
		item.frame = itemRect;
	
	}
	
	
}


- (void)dealloc {
    self.delegate = nil;
	
}

#pragma mark -
#pragma mark tab handling methods

-(void)userSelectedIndex:(NSInteger)index {
	
#if DEBUG
	NSLog(@"ACTabBarView.m -> userSelectedIndex: [%d]",index);
#endif
	_selectedItem = index;
	/*
	 set the rest of the items to normal
	 */
	for (int i=0; i<[items count]; i++) {
		ACTabBarItem *item = [items objectAtIndex:i];
#if DEBUG
		NSLog(@"item:%@  index:%d frame:%@",item._text.text,item.index,NSStringFromCGRect(item.frame));
#endif
		
		if(i!=index){
			

			[item setState:ACTabBarItemStateNormal];
			[item setBackgroundColor:[UIColor clearColor]];
			//[item.viewController.view removeFromSuperview];
		}
	}
	/*
	 call for redraw
	 */
	[self setNeedsLayout];
	
	
	if([self.delegate respondsToSelector:@selector(ACTabBarView:selectedTabItem:)]){
		ACTabBarItem *item = [items objectAtIndex:index];
		[self.delegate tabBar:self selectedTabItem:item];
		
	}
}

-(void)setSelectedItem:(NSInteger)index {
	
	[self userSelectedIndex:index];
}

-(void)setTabBarItem:(ACTabBarItem*)item atIndex:(NSInteger)index {
	item.index = index;
	[[items objectAtIndex:index] removeFromSuperview];
	[items replaceObjectAtIndex:index withObject:item];
	[self centerItemsOnRect:self.frame];
	[self setNeedsLayout];
}

-(void)deselectAllTabs {
#if DEBUG
	NSLog(@"ACTabBarView.m -> deselectAllTabs");
#endif
	_selectedItem = -1;
	for (ACTabBarItem *item in items) {
		//if ([[item viewController]view]  != nil) {
			
			
		//	[item.viewController.view removeFromSuperview];
			if (item.state!= ACTabBarItemStateDisabled) {
				item.state = ACTabBarItemStateNormal;
				[item setBackgroundColor:[UIColor clearColor]];
			}
		//}
	}
	[self setNeedsLayout];
	
}

-(void)deselectTab :(NSInteger)tab {
#if DEBUG
	NSLog(@"ACTabBarView.m -> deselectTab: [%d]",tab);
#endif
			_selectedItem = -1;
		ACTabBarItem *item = (ACTabBarItem*)[items objectAtIndex:tab];
		if (item.state!= ACTabBarItemStateDisabled) {
			item.state = ACTabBarItemStateNormal;
			[item setBackgroundColor:[UIColor clearColor]];
		}

		[item.viewController.view removeFromSuperview];

		item.viewController = nil;
		
	
	
	
}
#pragma mark -
#pragma mark  setters and getters

-(void)setItems:(NSMutableArray*)array {
	if (items !=array) {
		// remove old views from super view
		for (ACTabBarItem *item in items) {
			[item removeFromSuperview];
		}
		// release old array
		//create new array
		items = [NSMutableArray arrayWithArray:array];
		
		//center items
		[self centerItemsOnRect:self.frame];
		// add new 
		NSInteger index = 0;
		for (ACTabBarItem *item in items) {
#if DEBUG
			NSLog(@"item:%@  index:%d frame:%@",item._text.text,item.index,NSStringFromCGRect(item.frame));
#endif
			[self addSubview:item];
			item.index = index;
			index++;
		}
		if(self.superview)
			[self setNeedsLayout];
	}
	
}	
-(NSInteger)getSelectedIndex {
	
	return _selectedItem;
}

#pragma mark - 
#pragma mark left and right barbuttons

-(void)setRightACTabBarViewButton:(UIButton *)button {
    if (self.rightACTabBarViewButton) {
        
        [self.rightACTabBarViewButton removeFromSuperview];
        
    }
    rightACTabBarViewButton = button;
    rightACTabBarViewButton.frame = RIGHT_BAR_BUTTON_RECT_PORTRAIT;
    
    [self addSubview:rightACTabBarViewButton];
}
-(void)setLeftACTabBarViewButton:(UIButton *)button {
    if (leftACTabBarViewButton) {
        
        [leftACTabBarViewButton removeFromSuperview];
        
    }
    leftACTabBarViewButton = button;
    leftACTabBarViewButton.frame = LEFT_BAR_BUTTON_RECT;
    [self addSubview:self.leftACTabBarViewButton];
}

@end
