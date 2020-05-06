carljdp/ios2android
===================
*Forked from [Ninjanetic](https://github.com/Ninjanetic)/[ios2android](https://github.com/Ninjanetic/ios2android)*

**Purpose (original project)**

A simple script to port iOS retina images to the appropriate Android density buckets.

Porting an iOS application to Android is a time-consuming task, especially when you have to manually resize 1000 images from iPhone/iPad dimensions to Android density buckets and screen sizes. This script aims to save as much time as possible by automatically resizing these images for you.

**Purpose (this fork)**

Add functionality to handle:
- [ ] *Paths* and/or *filenames* containing special characters like *spaces* or *periods*.
- [ ] Handle faulty input - fail gracefuly
- [ ] Log operations & errors to file
- [ ] Terminal help file or manual


Prerequisites
-------------

[ImageMagick](http://www.imagemagick.org/script/binary-releases.php)

On Mac OS X, the easiest way to install ImageMagick is with [Homebrew](http://brew.sh/):

    brew install imagemagick


Usage
-----

1. Put the ios2android bash script somewhere in your path

2. Copy the retina iOS images you want to convert into an empty directory. 

3. From a terminal, cd into that directory and run:

```
$ ios2android
```


The script will evaluate each file in the directory, and determine if it is targeted for phone or tablet devices based on the filename. It will then create resized versions of the images and place them into the appropriately named density bucket folders. The script will also compensate for filenames that are not valid in android (such as images starting with numbers or containing hyphens).

Once the script is complete, simply copy the new folders into your Android project and you will have the equivalent of the iOS images. Way easier than manually scaling it yourself!

You can also create phone images directly from iPad images by specifying a scaling factor to use. Take a look at example 3 below.


Example
-------

1) A directory containing the following files:

```
intro_text@2x.png         (510 x 490 pixels)
intro_text@2x~ipad.png    (1222 x 1152 pixels)
```

will result in:

```
drawable-mdpi/intro_text.png          (255 x 245 pixels - 50%)
drawable-hdpi/intro_text.png          (383 x 368 pixels - 75%)
drawable-xhdpi/intro_text.png         (574 x 551 pixels - 112.5%)
drawable-large-mdpi/intro_text.png    (611 x 576 pixels - 50%)
drawable-large-hdpi/intro_text.png    (917 x 864 pixels - 75%)
drawable-large-xhdpi/intro_text.png   (1375 x 1296 pixels - 112.5%)
```



2) iPhone 5 4" images are treated the same as iPhone for 3.5" images, so a directory containing the following files:

```
intro_text-568h@2x.png         (510 x 490 pixels)
```

will result in:

```
drawable-mdpi/intro_text.png          (255 x 245 pixels - 50%)
drawable-hdpi/intro_text.png          (383 x 368 pixels - 75%)
drawable-xhdpi/intro_text.png         (574 x 551 pixels - 112.5%)
```



3) You can also specify a pre-scaling factor on the command line that is useful to create high-resolution phone images based solely on retina iPad images.

For example, if the iPad resources in your iOS project are 40% larger than the equivalent phone resources, you can specify a percentage on the command line when running the scripts to automatically create phone-sized images from just the iPad resources.

A directory containing the following files:
```
intro_text@2x~ipad.png    (1000 x 1000 pixels)
```

when processed with a 60% pre-scaling factor:
```
$ ios2android 0.60
```

will result in:
```
drawable-mdpi/intro_text.png        (300  x 300  px - 60% * 50%)
drawable-hdpi/intro_text.png        (450  x 450  px - 60% * 75%)
drawable-xhdpi/intro_text.png       (675  x 675  px - 60% * 112.5%)
drawable-xxhdpi/intro_text.png      (900  x 900  px - 60% * 150%)
drawable-large-mdpi/intro_text.png  (500  x 500  px - 50%)
drawable-large-hdpi/intro_text.png  (750  x 750  px - 75%)
drawable-large-xhdpi/intro_text.png (1125 x 1125 px - 112.5%)
```

More Information
----------------

For more information on re-scaling iOS images to Android, you can find a great web tool here:
- http://www.teehanlax.com/tools/density/


Licenses
--------

#### Original Project ([Ninjanetic](https://github.com/Ninjanetic)/[ios2android](https://github.com/Ninjanetic/ios2android))
> The MIT License (MIT)  
> Copyright (c) 2013 Ninjanetic Design Inc.  

#### This Fork ([carljdp](https://github.com/carljdp)/[ios2android](https://github.com/carljdp/ios2android))
> *Exact license to be determined*  
> Copyright (c) 2020 carljdp  
