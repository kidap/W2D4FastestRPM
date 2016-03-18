//
//  ViewController.m
//  W2D4FastestRPM
//
//  Created by Karlo Pagtakhan on 03/17/2016.
//  Copyright © 2016 AccessIT. All rights reserved.
//

#import "ViewController.h"

static const CGFloat maxRotation = 4.7;
static const CGFloat maxPositionOfNeedle = 7.2;
static const CGFloat minPositionOfNeedle = 2.5;


//From exercise
static const CGFloat min_degrees = -135.0;
static const CGFloat max_degrees = 135.0;
static const CGFloat range_degrees = max_degrees - min_degrees;
static const CGFloat limit_velocity = 7500.0;
static const CGFloat limit_velocity_delta = 10;
static const CGFloat reset_delay =0.1;
static const CGFloat velocity_delay = 0.1;

@interface ViewController ()

@property (nonatomic, strong) UIImageView *needleImageView;
@property (nonatomic, assign) CGPoint newPoint;
@property (nonatomic, assign) CGPoint lastPoint;
@property (nonatomic, assign) CGPoint lastSavedPoint;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger totalTime;
@property (nonatomic, assign) CGFloat currentRAD;
@property (nonatomic, assign) CGFloat velocityBetweenTimeInterval;

@end

@implementation ViewController

//MARK: View methods
- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  
  [self prepareView];
  [self prepareGesture];
  
  
}
//MARK: Preparation
- (void)prepareView {
  CGRect viewFrame = self.view.frame;
  CGFloat width = 300.0;
  CGFloat height = 300.0;
  CGFloat centerX = CGRectGetMidX(viewFrame) - (width/2);
  CGFloat centerY = CGRectGetMidY(viewFrame) - (height/2);
  CGRect thisFrame = CGRectMake(centerX, centerY, width, height);
  
  UIImageView * speedometerImageView = [[UIImageView alloc] initWithFrame:thisFrame];
  [speedometerImageView setImage:[UIImage imageNamed:@"speedometer"]];
  
  self.needleImageView = [[UIImageView alloc] initWithFrame:thisFrame];
  [self.needleImageView setImage:[UIImage imageNamed:@"needle"]];
  self.needleImageView.transform = CGAffineTransformMakeRotation(2.5);
  
  [self.view addSubview:speedometerImageView];
  [self.view addSubview:self.needleImageView];
  
  [self.view setBackgroundColor:[UIColor darkGrayColor]];
  
}

-(void)prepareGesture{
  UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                         action:@selector(handlePan:)];
  panGestureRecognizer.maximumNumberOfTouches = 1;
  [self.view addGestureRecognizer:panGestureRecognizer];
}

-(void)handlePan:(UIPanGestureRecognizer *)recognizer{
  switch (recognizer.state) {
    case UIGestureRecognizerStateBegan:
      [self startTimer];
    case UIGestureRecognizerStateChanged:
      self.lastSavedPoint = [recognizer velocityInView:self.view];
//      [self moveNeedleUsingVelocity:[recognizer velocityInView:self.view]];
//      [self moveNeedleWithVelocity:[self getHypothenusFromLastPoint2:[recognizer velocityInView:self.view]]];
      break;
    case UIGestureRecognizerStateEnded:
      self.lastPoint = CGPointZero;
      break;
    default:
      break;
  }
}
//MARK: Gesture handler
-(void) getVelocity:(CGPoint)cgpoint{
  [self getHypothenusFromLastPoint:cgpoint];
}
//MARK: Calculations
-(CGFloat)getHypothenusFromLastPoint2:(CGPoint)newPoint{
  
  CGFloat diffX = newPoint.x - self.lastSavedPoint.x;
  CGFloat diffY = newPoint.y - self.lastSavedPoint.y;
  
  CGFloat hypothenus = sqrtl( pow(diffX, 2) + pow(diffY, 2) );
  NSLog(@"3- x:%.2f y:%.2f hypothenus:%.2f",diffX, diffY, hypothenus);
  
  return hypothenus;
  
}
//-(void)moveNeedleWithVelocity:(CGFloat)velocity{
//  self.currVelocity = velocity;
//  
//  self.maxVelocity = MAX(self.maxVelocity, velocity);
//  CGFloat velocityProportion = velocity / limit_velocity;
//  
//  CGFloat degrees = MIN(range_degrees * velocityProportion, range_degrees );
//  
//  self.needleImageView.transform = CGAffineTransformRotate(self.minRotationTransform, RAD(degrees));
//}

-(CGFloat)getHypothenusFromLastPoint:(CGPoint)newPoint{
  
  CGFloat diffX = newPoint.x - self.lastSavedPoint.x;
  CGFloat diffY = newPoint.y - self.lastSavedPoint.y;
  
  CGFloat hypothenus = sqrtl( pow(diffX, 2) + pow(diffY, 2) );
  NSLog(@"3- x:%.2f y:%.2f hypothenus:%.2f",diffX, diffY, hypothenus);
  
  return hypothenus;
  
}
//-(void)moveNeedleUsingVelocity:(CGPoint)velocity{
//  
//  CGFloat diffX = velocity.x;
//  CGFloat diffY = velocity.y;
//  
//  CGFloat hypothenus = sqrtl( pow(diffX, 2) + pow(diffY, 2) );
//  
//  
//  NSLog(@"1- x:%.2f y:%.2f hypothenus:%.2f",diffX, diffY, hypothenus);
//  self.velocityBetweenTimeInterval += hypothenus;
//  
//  CGFloat turnByRAD = 0;
//  
//  if (hypothenus != 0){
//    turnByRAD = self.currentRAD + (hypothenus / 4000) * 4.2;
//    
//    NSLog(@"2- %f",turnByRAD);
//  } else{
//    turnByRAD = minPositionOfNeedle;
//  }
//  //turnByRAD -= 0.01;
//  turnByRAD = [self checkRADBounds:turnByRAD];
//  
//  //[UIView animateWithDuration:0.001 animations:^{
//    self.needleImageView.transform = CGAffineTransformMakeRotation(turnByRAD);
//  //}];
//  
//  
//}
//MARK: Timer
-(void)startTimer{
  self.timer = [NSTimer timerWithTimeInterval:0.1
                                       target:self
                                     selector:@selector(timerRunning)
                                     userInfo:nil
                                      repeats:YES];
  [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}
-(void)timerRunning{
  [self moveNeedle];
  
//  
//  //self.velocityBetweenTimeInterval
//  CGFloat turnByRAD = 0;
//  
//  NSLog(@"%f",self.velocityBetweenTimeInterval);
//  if (self.velocityBetweenTimeInterval != 0){
//    turnByRAD = self.currentRAD + (self.velocityBetweenTimeInterval / 7000) * 4.2;
//  } else{
//    turnByRAD = minPositionOfNeedle;
//  }
//  turnByRAD -= 0.01;
//  turnByRAD = [self checkRADBounds:turnByRAD];
//  
//  NSLog(@"%f",turnByRAD);
//  self.needleImageView.transform = CGAffineTransformMakeRotation(turnByRAD);
//  
//  
//  self.velocityBetweenTimeInterval = 0;
}

-(void) moveNeedle{
  
  NSLog(@"1- x:%.2f y:%.2f",self.lastPoint.x, self.lastPoint.y);
  NSLog(@"2- x:%.2f y:%.2f",self.lastSavedPoint.x, self.lastSavedPoint.y);
  
  CGFloat speed = [self getHypothenusFromLastPoint:self.lastPoint];
  CGFloat turnByRAD = 0;
  
  
  
  if (speed != 0){
    turnByRAD = self.currentRAD + (speed / 40000) * 4.2;
  } else{
    turnByRAD = MAX(minPositionOfNeedle,self.currentRAD);
      turnByRAD -= 0.10;
  }

  turnByRAD = [self checkRADBounds:turnByRAD];
  
  [UIView animateWithDuration:0.01 animations:^{
    self.needleImageView.transform = CGAffineTransformMakeRotation(turnByRAD);
  }];
  self.currentRAD = turnByRAD;
  
  self.lastSavedPoint = self.lastPoint;
}


-(CGFloat) checkRADBounds:(CGFloat)turn{
  return MIN(MAX(turn, minPositionOfNeedle), maxPositionOfNeedle);
}

@end
