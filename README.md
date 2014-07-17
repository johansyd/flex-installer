Flex installer
==============

flex installer: Installing flex SDK 4.12.1 from the command line for compiling actionscript and flex on Ubuntu.

###Dependencies:

The installation is done under the current user with all rights granted. sudo premission is required to be able to install the java dependencies system wide, but an option for local installation without sudo is also available.

jdk>=1.5 and ant>=1.7

###Tested on:

Ubuntu 12.04 precise
Ubuntu 10.04 lucid

##Install Flex SDK
    
NB: After you are finished with the install dialogs, get yourself a cup of coffe.

###Installation Ubuntu

The installation is done under the current user with all rights granted. You have option for installing the dependencies system wide or in a local folder.

    mkdir ~/flex
    cd ~/flex
    wget --no-check-certificate https://raw.githubusercontent.com/johansyd/flex-installer/master/install_flex.sh
    bash ./install_flex.sh

###Installation Mac OS x

Flex has a [Air installer](http://flex.apache.org/installer.html) for Mac OS X which is the easiest way.

###Installation Windows

Flex has a [Air installer](http://flex.apache.org/installer.html) for Windows which is the easiest way. 

##Usage

###Using the mxml flex mxmlc compiler for compiling flex applications.

-   [Tutorial](http://help.adobe.com/en_US/flex/using/WS2db454920e96a9e51e63e3d11c0bf69084-7fcc.html)
-   [Command line syntax](http://help.adobe.com/en_US/flex/using/WS2db454920e96a9e51e63e3d11c0bf69084-7ab6.html)
-   [Using abbreviated option names](http://help.adobe.com/en_US/flex/using/WS2db454920e96a9e51e63e3d11c0bf67670-7ff6.html)
-   [About the application compiler options](http://help.adobe.com/en_US/flex/using/WS2db454920e96a9e51e63e3d11c0bf69084-7a92.html)

###Using the component compiler for compiling swc libraries like OSMF.

-   [Using compc, the component compiler](http://help.adobe.com/en_US/flex/using/WS2db454920e96a9e51e63e3d11c0bf69084-7fd2.html)

###Installing Flex to use it with eclipse.

https://code.google.com/p/fb4linux/

###Installing the flash debug player

https://www.adobe.com/support/flashplayer/downloads.html

###Using FlashFirebug in firefox

Install from: http://o-minds.com/products/flashfirebug

###Using Monster debugger

Go to: http://www.demonsterdebugger.com/

###Using Firebug in firefox

clone from: https://github.com/johansyd/console
