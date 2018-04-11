# WWDC-2018

I created this project for the [Apple WWDC Scholarship](https://developer.apple.com/wwdc/scholarships/)

## **About this app**</br>

The goal of this app is to visualize key sorting algorithms: `Selection`, `Quick` and `Bubble` sorts.</br>
Seeing algorithms in action helps to understand how they work and adds more fun to the process of mastering of the Computer Science. 

A user will see 3 unsorted arrays of digits. By clicking the play button, an array will be sorted step by step.</br>
In addition, a user can pause, move to the previous or next step.

## **Tech Overview**</br>
- This app was created using `Swift Playground`. `Sketch` was used for design and exporting to `Zeplin`. All pictures were found on free stock photos websites.  
- To display every step in the UI I created an operation for each movement of elements in the array.
- I used my open source libraries:</br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [Listable](https://github.com/devMEremenko/listable) was used to manage Collection and Table views. </br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [EasyCalls](https://github.com/devMEremenko/EasyCalls) was used to dispatch an execution to and from the main queue.</br>
- Other open source libraries:</br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [SnapKit](https://github.com/SnapKit/SnapKit) was used to create AutoLayout for views in the code.</br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [Hero](https://github.com/lkzhao/Hero) allows creating transitions in a declarative way. </br>
- Cells width was calculated for any picture size for their user-friendly displaying in the picture gallery of my profile screen.
- `VIPER` was used as a preferred architecture for the sorting screen.
- All views were created on my own. 
- Animations were created via `UIView`. `Timer` was used to launch them at the appropriate time. 
- `Swift Enums` were very useful to manage states of user interactions and animations.

Watch the video below to see the app in action:

[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/i1Xdys91hqc/0.jpg)](https://www.youtube.com/watch?v=i1Xdys91hqc)

## Author

[Maksym Eremenko](https://www.linkedin.com/in/maxim-eremenko/), devmeremenko@gmail.com

## License
```
Copyright (c) 2018 Maxim Eremenko <devmeremenko@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```
