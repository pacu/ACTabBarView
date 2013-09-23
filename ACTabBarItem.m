//
//  GSTabBarItem.m
//  iPadMagazine
//
//  Created by Francisco Gindre on 1/17/11.
//  Copyright 2011 AppCrafter.biz. All rights reserved.
//

#import "ACTabBarItem.h"
#import "ACTabBarView.h"
#import "GraphicFunctions.h"
@implementation ACTabBarItem

@synthesize viewController;
@synthesize index;
@synthesize _text;


//void GSContextAddRoundRect(CGContextRef context, CGRect rect, float radius);
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		
		_imageArray = [[NSMutableArray alloc] initWithCapacity:3];
		for (int i=0; i<3; i++) {
			[_imageArray addObject:[NSNull null]];
		}
		_text = [[UILabel alloc] init];
		_text.font = [UIFont fontWithName:@"Arial-BoldMT" size:10];
		_text.textColor = [UIColor colorWithRed:0.7	green:0.7 blue:0.7 alpha:1];
		_text.textAlignment = UITextAlignmentCenter;
		_text.lineBreakMode = UILineBreakModeTailTruncation;
		_text.numberOfLines = 1;
		_text.backgroundColor = [UIColor clearColor];
		_text.frame = CGRectMake(0, 34, self.frame.size.width, 10);
		self.backgroundColor =[UIColor clearColor];
		
		
    }
    return self;
}

-(id)initWithViewController:(UIViewController*)theViewController image:(UIImage*)normalStateImage andtext:(NSString*)textOrNil{
	
	//self = [[[NSBundle mainBundle] loadNibNamed:@"GSTabBarItem" owner:self options:nil] objectAtIndex:0];
	self = [self initWithFrame:CGRectMake(0, 0, 76, 44)];
#if DEBUG 
	NSLog(@"GSTabBar.m -> initWithViewController tabbar item :%@",self);
	//NSLog(@"super: %@",super);
#endif
	if(self){
		
		[_imageArray replaceObjectAtIndex:ACTabBarItemStateNormal withObject:normalStateImage];
		self.viewController =theViewController;
		
		[_text setText:textOrNil];
		
		imageView = [[UIImageView alloc] initWithFrame:CGRectMake(23, 3, 30, 30)];
		imageView.contentMode = UIViewContentModeScaleAspectFit;
		UIImage *image = (UIImage*)[_imageArray objectAtIndex:ACTabBarItemStateNormal];
		[imageView setImage:image];
		[self addSubview:imageView];
		[self addSubview:_text];
		state = ACTabBarItemStateNormal;
		
	
		/* add gesture to detect tap */
		
		UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
		tap.numberOfTapsRequired =1;
		tap.numberOfTouchesRequired = 1;
		[self addGestureRecognizer:tap];
	}
	return self;
	
	
	
}



#pragma mark drawing methods
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code.
//
//	
//	
//}

-(void)setImage:(UIImage*)image forState:(ACTabBarItemState)aState {
	[_imageArray replaceObjectAtIndex:aState withObject:image];

}
#pragma mark - 
#pragma mark  gesture FUNCTION

-(void)handleGesture:(UIGestureRecognizer*)gesture {
#if DEBUG 
	NSLog(@"gesture in GSTabBar. Super view : %@", self.superview);
#endif
	if ([self.superview respondsToSelector:@selector(userSelectedIndex:)]) {
		
	
		[(ACTabBarView*)[self superview] userSelectedIndex:index];
	}
	[self setState:ACTabBarItemStateSelected];
	[self setNeedsDisplay];
}

#pragma mark - 
#pragma mark state handling

-(void)setState:(ACTabBarItemState)newState {
	if (state!=newState) {
		state = newState;
		UIImage *stateImage = [_imageArray objectAtIndex:newState];
		/*
		 if the image for highlighted state does not exist leave the normal state image
		 */
		if ((NSNull*)stateImage != [NSNull null]) {
			[imageView setImage:stateImage];
		}else if (newState == ACTabBarItemStateSelected) {
			[imageView setImage:[_imageArray objectAtIndex:ACTabBarItemStateNormal]];
		}	
		[self setBackgroundColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.2]];
		[self setNeedsDisplay];
	}
		
}

-(ACTabBarItemState)getState {
	return state;
}
	
	



@end
