Flex installer
==============

flex-installer Installing flex SDK 4.12.1 from the command line for compiling actionscript and flex.

###Dependencies:

jdk>=1.5 and ant>=1.7

###Tested on:

Ubuntu 12.04 precise
Ubuntu 10.04 lucid
Cygwin64 (Windows)

##Install Flex SDK
    
NB: After you are finished with the install dialogs, get yourself a cup of coffe.

###Installation Ubuntu

The installation is done under the current user with all rights granted. You have option for installing the dependencies system wide or in a local folder.

    mkdir ~/flex
    cd ~/flex
    wget --no-check-certificate https://raw.githubusercontent.com/johansyd/flex-installer/master/install_flex.sh
    bash ./install_flex.sh

###Installation Mac OS x

Flex has a [Air installer](http://flex.apache.org/installer.html) for Mac OS X whic is the easiest way.
If you want to use this installer because you need to install from the command line then this installer should work as long as you do not install the dependencies system wide or install them before you start the installer. If you want to do this you should install ant first. Java JDK usually comes preinstalled, but check just in case.

    # install x code https://developer.apple.com/xcode/
    # Then install wget
    xcode-select --install
    cd ~/Downloads
    curl -O http://ftp.gnu.org/gnu/wget/wget-1.14.tar.gz
    tar -zxvf wget-1.14.tar.gz
    cd wget-1.14/
    ./configure 
    # if you get an error like this:configure: error: --with-ssl was given, but GNUTLS is not available. 
    # then configure wget like this: ./configure --with-ssl=openssl
    make
    sudo make install
    cd /Applications/Utilities/
    java -version # install jdk if the system asks you. 
    ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
    brew update
    brew install ant
    # Then install flex
    mkdir ~/flex
    cd ~/flex
    wget --no-check-certificate https://raw.githubusercontent.com/johansyd/flex-installer/master/install_flex.sh
    bash ./install_flex.sh

###Installation Windows

Flex has a [Air installer](http://flex.apache.org/installer.html) for Windows which is the easiest way. 
If you want to install from terminal you need to install [Cygwin](http://cygwin.com/install.html "Cygwin") first.
Open a cygwin terminal window after you installed cywin and do this:

    mkdir ~/flex
    cd ~/flex
    wget --no-check-certificate https://raw.githubusercontent.com/johansyd/flex-installer/master/install_flex.sh
    bash ./install_flex.sh

##Using the mxml flex compiler.

-   [Tutorial](http://help.adobe.com/en_US/flex/using/WS2db454920e96a9e51e63e3d11c0bf69084-7fcc.html)
-   [Command line syntax](http://help.adobe.com/en_US/flex/using/WS2db454920e96a9e51e63e3d11c0bf69084-7ab6.html)
-   [Using abbreviated option names](http://help.adobe.com/en_US/flex/using/WS2db454920e96a9e51e63e3d11c0bf67670-7ff6.html)
-   [About the application compiler options](http://help.adobe.com/en_US/flex/using/WS2db454920e96a9e51e63e3d11c0bf69084-7a92.html)

##Installing Flex to use it with eclipse.

https://code.google.com/p/fb4linux/

##Installing the flash debug player

https://www.adobe.com/support/flashplayer/downloads.html

##Using FlashFirebug in firefox

Install from: http://o-minds.com/products/flashfirebug
