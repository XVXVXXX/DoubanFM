DoubanFM
========
---
github:@[XVXVXXX](https://github.com/XVXVXXX)  
csdn:@[XVXVXXX](http://blog.csdn.net/xwj0918030230)  
please open DoubanFM.xcworkspace in ProjectFinal

---

---


The DoubanFM for iPhone,using MPMoviePlayer
 
&AFNetworking@[AFNetworking/AFNetworking](https://github.com/AFNetworking/AFNetworking)
  
&doubanAPI@[ampm/Douban-FM-sdk](https://github.com/ampm/Douban-FM-sdk)  @[HakurouKen/douban.fm-api](https://github.com/HakurouKen/douban.fm-api)

&CDSideBarController @[christophedellac/CDSideBarController](https://github.com/christophedellac/CDSideBarController)

---

###侧栏界面
1. 侧栏采用了CDSideBarController  
2. 结构实际上是tabbarController   
   * 第一view是播放界面
   * 第二view是选择频道界面
   * 第三view是登陆界面 
   * 第四X是取消sidebar的选取  
   
---   

![](https://github.com/XVXVXXX/DoubanFM/raw/master/readmeImage/page0.png)

---   

###播放界面
1. 当前选定的channel 在点击第二view的tableviewcell时用改变appDelegate设定
2. 当前播放歌曲所属专辑的cover 用的是AFN的[UIImageViewController setImageWithURL:(NSURL *)url];
3. 歌曲进度条Progressbar 用了NStimer
4. 歌曲的title,artist
5. buttons,包括pause/play,like,ban,skip.都是通过AFN向douban发送request获取新的playlist  

---

![](https://github.com/XVXVXXX/DoubanFM/raw/master/readmeImage/page1.png)

---   

###选择频道界面
1. 目前按照doubanFM官方的写了类似的，在登陆之后，获得的频道和歌曲都会不一样，推荐频道会变多，红心歌曲也会同步到douban那边的数据  
2. 点击相应的频道可以获取相应的playlist，同时主页信息也会更新  
3. 红心频道在没有数据的情况下，会有alertView提示

---

![](https://github.com/XVXVXXX/DoubanFM/raw/master/readmeImage/page2.png)

---

###用户信息界面
1. 未登陆时只提供一个登陆的接口，下面的数据在没登陆的情况下，只会显示0，在登陆后则会根据用户信息更新
2. 其中的登陆不是一个button，而是一个imageView添加了手势功能  
3. 用户点击上面的登陆之后，会presentViewController: LoginViewController

---
![](https://github.com/XVXVXXX/DoubanFM/raw/master/readmeImage/page3.png)

---

###登录界面
1. 登陆界面包括账号、密码和验证码
2. 验证码也是来自douban方提供的，原理是先向douban申请一个captchaID，然后用这个返回的captchaID申请一个验证码图片。
3. 点击登陆的时候，parameter包括账号、密码、验证码、验证码ID，如果登陆成果就会dismiss:self,然后回到之前的界面，更新信息；登陆失败则有相应的错误信息用alertview显示。登陆成功要记录用户登陆的一系列数据，之后设置有用。
4. 点击取消则是直接dismiss：self，给了一个退出 LogginViewController的接口。

---
![](https://github.com/XVXVXXX/DoubanFM/raw/master/readmeImage/page4.png)

---
###登陆成功界面
1. 登陆成功就会更新信息，包括头像、昵称、自己在douban电台的播放信息，包括了played,liked,banned
2. 头像其实还是刚才的登陆的图片，还是用AFN的setimagewithurl:,然后把图片的交互关闭就好了，_loginImage.userInteractionEnabled = NO;同时将下面原本hidden的but显示n登出，button.hidden = 
3. 点击登出就会进行登出操作，实际上也是向douban发送一个request，parameter中带了之前登录时返回的一个cookies。有问题的话，会登出失败的（囧)  
  
---  

![](https://github.com/XVXVXXX/DoubanFM/raw/master/readmeImage/page5.png)

---
###remote control
1. 从屏幕底部滑出处进行remotecontrol  
![](https://github.com/XVXVXXX/DoubanFM/raw/master/readmeImage/page6.png)
2. 在lock情况下进行remotecontrol  
![](https://github.com/XVXVXXX/DoubanFM/raw/master/readmeImage/page7.png)