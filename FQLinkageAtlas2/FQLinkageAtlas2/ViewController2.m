//
//  ViewController2.m
//  imageThree
//
//  Created by 冯倩 on 2016/11/21.
//  Copyright © 2016年 冯倩. All rights reserved.
//

#import "ViewController2.h"

@interface ViewController2 ()<UIScrollViewDelegate,UIGestureRecognizerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UIScrollView        *_mainScrollView;     //中间主scrollView
    UIPageControl       *_wheelPageControl;
    UIScrollView        *_bottomScrollView;   //底部scrollView
    UIView              *_underLineView;      //底部线条
    UIImageView         *_image1;
    UIImageView         *_image2;
    UIImageView         *_image3;
    NSArray             *_imageArray;         //图片数组
    NSInteger           _currentImageIndex;   //滑动时记录当前数组下标
}


@end

@implementation ViewController2

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"图片";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initData];
    [self layoutUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - InitData
- (void)initData
{
    _imageArray = @[@"http://image.photophoto.cn/m-15/Identifiers/Number/0370060487.jpg",
                    @"http://d.hiphotos.baidu.com/zhidao/wh%3D600%2C800/sign=bbde1034d62a283443f33e0d6b85e5d2/4bed2e738bd4b31c5c86949285d6277f9e2ff865.jpg",
                    @"http://img.sootuu.com/vector/200801/097/479.jpg",
                    @"http://hiphotos.baidu.com/yirenqixi/pic/item/11cedd8fed1fb2fc503d92ac.jpg",
                    @"http://img.incake.net/UpImages/xin/172-1.png",
                    @"http://pic17.nipic.com/20111122/8372622_104529289168_2.jpg",
                    @"http://image.photophoto.cn/nm-15/037/006/0370060386.jpg",
                    @"http://imgm.photophoto.cn/015/037/006/0370060145.jpg",
                    @"http://img.taopic.com/uploads/allimg/140306/235030-140306150U849.jpg",
                    @"http://img.incake.net/UpImages/xin/177-1.png",
                    @"http://img2.ooopic.com/14/64/33/47bOOOPIC7c_202.jpg",
                    @"http://pic.wenwen.soso.com/p/20091001/20091001052655-375871054.jpg",
                    @"http://y1.ifengimg.com/cmpp/2014/06/13/09/f66972b9-a8a7-4670-9fa9-e5fe32cdbe56.jpg",
                    @"http://e.hiphotos.baidu.com/zhidao/wh%3D600%2C800/sign=5bbb462fd000baa1ba794fbd7720952a/55e736d12f2eb9385fd6f131d4628535e4dd6fbe.jpg"
                    ];
    _currentImageIndex = 0;
}

#pragma mark - LayoutUI
- (void)layoutUI
{
    //_mainScrollView
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 100, self.view.width, self.view.height - 300)];
    _mainScrollView.delegate = self;
    _mainScrollView.bounces = NO;
    _mainScrollView.backgroundColor = [UIColor grayColor];
    _mainScrollView.showsHorizontalScrollIndicator=YES;
    _mainScrollView.showsVerticalScrollIndicator=YES;
    _mainScrollView.contentSize = CGSizeMake(self.view.width * 3, 0);
    _mainScrollView.pagingEnabled = YES;
    [_mainScrollView setContentOffset:CGPointMake(self.view.width, 0) animated:NO];
    [self.view addSubview:_mainScrollView];
    //三个UIImageView
    _image1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _mainScrollView.width, _mainScrollView.height)];
    _image1.backgroundColor = [UIColor redColor];
    _image1.contentMode = UIViewContentModeScaleAspectFit;
    _image2 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.width, 0, _mainScrollView.width, _mainScrollView.height)];
    _image2.backgroundColor = [UIColor greenColor];
    _image2.contentMode = UIViewContentModeScaleAspectFit;
    _image3 = [[UIImageView alloc] initWithFrame:CGRectMake(2*self.view.width, 0,_mainScrollView.width, _mainScrollView.height)];
    _image3.backgroundColor = [UIColor blueColor];
    _image3.contentMode = UIViewContentModeScaleAspectFit;
    
    for (UIImageView * img in @[_image1,_image2,_image3])
    {
        //添加缩放手势
        [img setUserInteractionEnabled:YES];
        [img setMultipleTouchEnabled:YES];
        UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
        [img addGestureRecognizer:pinchGestureRecognizer];
        [_mainScrollView addSubview:img];
    }
    
    //UIPageControl
    _wheelPageControl = [[UIPageControl alloc] init];
    _wheelPageControl.numberOfPages = _imageArray.count;
    _wheelPageControl.currentPage = 0;
    CGPoint p = CGPointMake(self.view.width * 0.5, 0.8 * self.view.height);
    _wheelPageControl.center = p;
    _wheelPageControl.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_wheelPageControl];
    //上面数据初始化
    [self updateScrollImage];
    
    //底部ScrollView
    _bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.view.height - 70, self.view.width, 70)];
    _bottomScrollView.backgroundColor = [UIColor whiteColor];
    _bottomScrollView.delegate = self;
    _bottomScrollView.bounces = NO;
    _bottomScrollView.showsHorizontalScrollIndicator=NO;
    _bottomScrollView.showsVerticalScrollIndicator=NO;
    _bottomScrollView.contentSize = CGSizeMake(70 * _imageArray.count, 0);
    [self.view addSubview:_bottomScrollView];
    
    //循环添加
    for (int i = 0; i < _imageArray.count; i ++)
    {
        //底部
        UIButton *bottomBtn = [[UIButton alloc] init];
        bottomBtn.frame = CGRectMake(70 * i, 0, 70, 70);
        bottomBtn.tag = i;
        [bottomBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:_imageArray[i]] forState:UIControlStateNormal];
        bottomBtn.contentMode = UIViewContentModeScaleAspectFit;
        [bottomBtn addTarget:self action:@selector(bottomBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomScrollView addSubview:bottomBtn];
        
        
    }
    
    //底部线条
    _underLineView = [[UIView alloc] initWithFrame:CGRectMake(0, _bottomScrollView.height - 2, 70, 2)];
    _underLineView.backgroundColor = [UIColor redColor];
    [_bottomScrollView addSubview:_underLineView];
    
    if (_imageArray.count == 1)
    {
        _mainScrollView.scrollEnabled = NO;
        _bottomScrollView.scrollEnabled = NO;
    }
    
}

#pragma mark - Methods
-(void) updateScrollImage
{
    //滑动时重置坐标
    _image1.frame = CGRectMake(0, 0,_mainScrollView.width,_mainScrollView.height);
    _image2.frame = CGRectMake(self.view.width, 0, _mainScrollView.width, _mainScrollView.height);
    _image3.frame = CGRectMake(2*self.view.width, 0,_mainScrollView.width, _mainScrollView.height);

    
    //page为当前页数,数组下标
    int page = _mainScrollView.contentOffset.x /_mainScrollView.frame.size.width;
    //左滑
    if (page == 0)
    {
        _currentImageIndex = (_currentImageIndex + _imageArray.count - 1) % _imageArray.count;
    }
    //右滑
    else if(page == 2)
    {
        _currentImageIndex = (_currentImageIndex + 1) % _imageArray.count;
    }
    
    NSInteger left;
    NSInteger right;
    
    left = (int)(_currentImageIndex + _imageArray.count -1) % _imageArray.count;
    right = (int)(_currentImageIndex + 1) % _imageArray.count;
    
    [_image1 sd_setImageWithURL:[NSURL URLWithString:_imageArray[left]]];
    [_image2 sd_setImageWithURL:[NSURL URLWithString:_imageArray[_currentImageIndex]]];
    [_image3 sd_setImageWithURL:[NSURL URLWithString:_imageArray[right]]];
    
    //偏移回来
    [_mainScrollView setContentOffset:CGPointMake(_mainScrollView.width, 0) animated:NO];
    _wheelPageControl.currentPage = _currentImageIndex;
    
    NSLog(@"数组下标为%ld",_currentImageIndex);
    
}

- (CGFloat)countOffSet:(CGFloat )x
{
    //计算底部scrollView的偏移量
    CGFloat realOffSetX = x - _bottomScrollView.width / 2;
    if (realOffSetX < 0)
    {
        realOffSetX = 0;
    }
    CGFloat maxOffSetX = _bottomScrollView.contentSize.width - _bottomScrollView.width;
    if (realOffSetX > maxOffSetX)
    {
        realOffSetX = maxOffSetX;
    }
    if (maxOffSetX < 0)
        realOffSetX = 0;
    
    return realOffSetX;
}

// 处理缩放手势
- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    UIView *view = pinchGestureRecognizer.view;
    
    NSLog(@"这个View是%@ 缩放为%f",pinchGestureRecognizer.view,pinchGestureRecognizer.scale);
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        pinchGestureRecognizer.scale = 1;
    }
}

#pragma mark - Actions
//点击底部按钮显示
- (void)bottomBtnAction:(UIButton *)sender
{
    //动画
    [UIView animateWithDuration:0.5 animations:^
     {
         [_image2 sd_setImageWithURL:[NSURL URLWithString:_imageArray[sender.tag]]];
         
         [_bottomScrollView setContentOffset:CGPointMake([self countOffSet:sender.center.x], 0) animated:NO];
         _underLineView.frame = CGRectMake(sender.tag * 70, _bottomScrollView.height - 2, 70, 2);
     }];
    
     _currentImageIndex = sender.tag;

    
}




#pragma mark - UIScrollView

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _mainScrollView)
    {
        [self updateScrollImage];
        int page = scrollView.contentOffset.x / scrollView.width;  //偏移了几张图
        //左滑
        if (page == 0)
        {
            _currentImageIndex = (_currentImageIndex + _imageArray.count - 1) % _imageArray.count;
        }
        //右滑
        else if(page == 2)
        {
            _currentImageIndex = (_currentImageIndex + 1) % _imageArray.count;
        }
        
        //动画
        [UIView animateWithDuration:0.5 animations:^
         {
             //底部scrollView和红线跟着偏移
             [_bottomScrollView setContentOffset:CGPointMake([self countOffSet: (_currentImageIndex + 1) * 70 - 35 ], 0) animated:NO];
             _underLineView.frame = CGRectMake(_currentImageIndex * 70, _bottomScrollView.height - 2, 70, 2);
             
         }];
    }
    else
        NSLog(@"jdjnfjewdnwqdqwnd nd csdc mdnemn");
}



@end
