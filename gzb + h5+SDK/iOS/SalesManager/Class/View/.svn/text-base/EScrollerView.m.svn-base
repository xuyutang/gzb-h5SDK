//
//  EScrollerView.m
//  icoiniPad
//
//  Created by Ethan on 12-11-24.
//
//

#import "EScrollerView.h"
#import "SDImageView+SDWebCache.h"
#import "GlobalConstant.h"

#define rightDirection 1
#define leftDirection 0

@implementation EScrollerView
@synthesize delegate,currentPageIndex;

- (void)dealloc {
	[scrollView release];
    [noteTitle release];
	delegate=nil;
    if (pageControl) {
        [pageControl release];
    }
    if (imageArray) {
        [imageArray release];
        imageArray=nil;
    }
    if (titleArray) {
        [titleArray release];
        titleArray=nil;
    }
    [super dealloc];
}
-(id)initWithFrameRect:(CGRect)rect ImageArray:(NSArray *)imgArr TitleArray:(NSArray *)titArr isBig:(BOOL)bBig
{
    page=0;//设置当前页为1
    
	if ((self=[super initWithFrame:rect])) {
        
        [self setBackgroundColor:WT_LIGHT_YELLOW];
        
        self.userInteractionEnabled=YES;
        titleArray=[titArr retain];
        NSMutableArray *tempArray=[NSMutableArray arrayWithArray:imgArr];
        [tempArray insertObject:[imgArr objectAtIndex:([imgArr count]-1)] atIndex:0];
        [tempArray addObject:[imgArr objectAtIndex:0]];
		imageArray=[[NSArray arrayWithArray:tempArray] retain];
		viewSize=rect;
        NSUInteger pageCount=[imageArray count];
        scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, viewSize.size.width, viewSize.size.height)];
        scrollView.pagingEnabled = YES;
        scrollView.contentSize = CGSizeMake(viewSize.size.width * pageCount, viewSize.size.height);
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.scrollsToTop = NO;
        scrollView.delegate = self;
        [scrollView setBackgroundColor:WT_LIGHT_YELLOW];
        
        for (int i=0; i<pageCount; i++) {
            NSString *imgURL=[imageArray objectAtIndex:i];
            UIImageView *imgView=[[[UIImageView alloc] init] autorelease];
            [imgView setBackgroundColor:WT_LIGHT_YELLOW];
            imgView.contentMode = UIViewContentModeScaleAspectFill;
            if ([imgURL hasPrefix:@"http://"]) {
                //网络图片 请使用ego异步图片库
                //[imgView setImageWithURL:[NSURL URLWithString:imgURL]];
                [imgView setImageWithURL:[NSURL URLWithString:imgURL] refreshCache:NO placeholderImage:[UIImage imageNamed:@"default_pic"]];
            }
            else
            {
                
                UIImage *img=[UIImage imageNamed:[imageArray objectAtIndex:i]];
                [imgView setImage:img];
            }
            
            [imgView setFrame:CGRectMake(viewSize.size.width*i, 0,viewSize.size.width, viewSize.size.height)];
            imgView.tag=i-1;
            if (i == [imageArray count]-1) {
                imgView.tag = 0;
            }else
            if (i == 0) {
                imgView.tag=[imageArray count]-1;
            }
            
            UITapGestureRecognizer *Tap =[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imagePressed:)] autorelease];
            [Tap setNumberOfTapsRequired:1];
            [Tap setNumberOfTouchesRequired:1];
            imgView.userInteractionEnabled=YES;
            [imgView addGestureRecognizer:Tap];
            [scrollView addSubview:imgView];
        }
        [scrollView setContentOffset:CGPointMake(viewSize.size.width, 0)];
        [self addSubview:scrollView];

        //说明文字层
        if (bBig) {
            
            if (((NSString *)[titleArray objectAtIndex:0]).length >0) {
              
                UIView *noteView=[[UIView alloc] initWithFrame:CGRectMake(0, 290,320,160)];
                [noteView setBackgroundColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.5]];

                float pageControlWidth=(pageCount-2)*10.0f+40.f;
                float pagecontrolHeight=20.0f;
                pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(5,100, pageControlWidth, pagecontrolHeight)];
                pageControl.currentPage=0;
                pageControl.numberOfPages=(pageCount-2);
                [noteView addSubview:pageControl];
            
                noteTitle=[[UILabel alloc] initWithFrame:CGRectMake(5, 6, self.frame.size.width-15, 100)];
                [noteTitle setText:[titleArray objectAtIndex:0]];
                [noteTitle setBackgroundColor:[UIColor clearColor]];
                [noteTitle setFont:[UIFont systemFontOfSize:13]];
                //[noteTitle setTextColor:WT_YELLOW];
                noteTitle.numberOfLines = 0;
                [noteView addSubview:noteTitle];
            
                [self addSubview:noteView];
                [noteView release];
            }

        }else{
            UIView *noteView=[[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-33,self.bounds.size.width,33)];
            [noteView setBackgroundColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.5]];
        
            float pageControlWidth=(pageCount-2)*10.0f+40.f;
            float pagecontrolHeight=20.0f;
            pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake((self.frame.size.width-pageControlWidth),6, pageControlWidth, pagecontrolHeight)];
            pageControl.currentPage=0;
            pageControl.numberOfPages=(pageCount-2);
            [noteView addSubview:pageControl];
        
            noteTitle=[[UILabel alloc] initWithFrame:CGRectMake(5, 6, self.frame.size.width-pageControlWidth-15, 20)];
            [noteTitle setText:[titleArray objectAtIndex:0]];
            [noteTitle setBackgroundColor:[UIColor clearColor]];
            [noteTitle setFont:[UIFont systemFontOfSize:13]];
            //[noteTitle setTextColor:WT_YELLOW];
            [noteView addSubview:noteTitle];
        
            [self addSubview:noteView];
            [noteView release];
        }
        
        if (imageArray.count > 1) {
            //NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(changeView) userInfo:nil repeats:YES];
        }
	}
	return self;
}


- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pageWidth = scrollView.frame.size.width;
    int pageIndex = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    currentPageIndex=pageIndex;
       
    pageControl.currentPage=(pageIndex-1);
    int titleIndex=pageIndex-1;
    if (titleIndex==[titleArray count]) {
        titleIndex=0;
        pageControl.currentPage=titleIndex;
    }
    if (titleIndex<0) {
        titleIndex=[titleArray count]-1;
        pageControl.currentPage=titleIndex;
    }
    
    if(titleIndex > [titleArray count]){
        titleIndex=0;
    }
    [noteTitle setText:[titleArray objectAtIndex:titleIndex]];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView
{
    if (currentPageIndex==0) {

        [_scrollView setContentOffset:CGPointMake(([imageArray count]-2)*viewSize.size.width, 0)];
        if ([delegate respondsToSelector:@selector(EScrollerViewEnableScroll:)]) {
           // [delegate EScrollerViewEnableScroll:NO];
        }
        
    }
    if (currentPageIndex==([imageArray count]-1)) {
       
        [_scrollView setContentOffset:CGPointMake(viewSize.size.width, 0)];
        if ([delegate respondsToSelector:@selector(EScrollerViewEnableScroll:)]) {
           // [delegate EScrollerViewEnableScroll:NO];
        }
    }

    
}


-(void)changeView
{

    [self performSelectorOnMainThread:@selector(scrollViewDidScroll:) withObject:scrollView waitUntilDone:YES];
    [self performSelectorOnMainThread:@selector(scrollViewDidEndDecelerating:) withObject:scrollView waitUntilDone:YES];
    [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x + 320.f, scrollView.contentOffset.y) animated:YES];
    
    if ([delegate respondsToSelector:@selector(EScrollerViewEnableScroll:)]) {
        [delegate EScrollerViewEnableScroll:YES];
    }

}
- (void)imagePressed:(UITapGestureRecognizer *)sender
{

    if ([delegate respondsToSelector:@selector(EScrollerViewDidClicked:)]) {
        [delegate EScrollerViewDidClicked:sender.view.tag];
    }
}

@end
