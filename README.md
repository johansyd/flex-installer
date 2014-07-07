flex-installer
==============

flex-installer Installing flex SDK 4.12.1 from the command line for compiling actionscript and flex.

###Installation Ubuntu

The installation is done under the current user with all rights granted. sudo premission is required to be able to install the java dependencies

####Dependencies:

jdk>=1.5 and ant>=1.7

####Tested on:

Ubuntu 12.04 precise, 10.04 lucid

####Install Flex SDK

    git clone git@github.com:johansyd/flex-installer.git
    mkdir ~/flex
    cp flex-installer/install_flex.sh ~/flex/install.sh
    cd ~/flex
    chmod 711 ./install.sh
    ./install.sh

NB: After you are finished with the install dialogs, get yourself a cup of coffe.

####Using the mxml flex compiler.

####Installing Flex to use it with eclipse.

https://code.google.com/p/fb4linux/

####Installing the flash debug player

https://www.adobe.com/support/flashplayer/downloads.html

####Using FlashFirebug in firefox

Install from: http://o-minds.com/products/flashfirebug
