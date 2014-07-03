#/bin/bash!
## Documentation source: https://cwiki.apache.org/confluence/display/FLEX/Installation+help#Installationhelp-Ant-basedinstaller
## Latest binaries: http://flex.apache.org/download-binaries.html
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
read -p "Flex compiler requires java. java-package, openjdk-7-jdk and ant will be installed. Is this OK with you? [Y|y|N|n]:" -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi
(sudo apt-get install java-package openjdk-7-jdk ant -y && echo 'Java SDK installed.') || (echo 'Something went wrong. Java SDK not installed.' && exit 1)
read -p "Everything starting with apache-flex-sdk-4.12.1-bin will be removed from $dir. Is this OK with you? [Y|y|N|n]:" -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi
rm -rf $dir/apache-flex-sdk-4.12.1-bin*
(wget http://apache.uib.no/flex/4.12.1/binaries/apache-flex-sdk-4.12.1-bin.tar.gz && echo 'flex source downloaded.') || (echo 'Something went wrong. flex sourc not downloaded.' && rm -rf $dir/apache-flex-sdk-4.12.1-bin* && exit 1)
(tar zxvf apache-flex-sdk-4.12.1-bin.tar.gz && echo 'flex source uncompressed.') || (echo 'Something went wrong. flex source not uncompressed.' && rm -rf $dir/apache-flex-sdk-4.12.1-bin* && exit 1)
cd $dir/apache-flex-sdk-4.12.1-bin/ && echo 'changed directory.'
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
(ant -f installer.xml -Dair.sdk.version=2.6 && echo 'flex binary built.') || (echo 'Something went wrong. flex binary not built.' && exit 1)
mkdir -p $dir/frameworks/libs/player/11.1/ && echo 'directory created.'
(wget http://download.macromedia.com/get/flashplayer/updaters/11/playerglobal11_1.swc -O $dir/frameworks/libs/player/11.1/playerglobal.swc && echo 'flash player 11.1 downloaded.') || (echo 'Something went wrong. flash player 11.1 not downloaded.' && exit 1)
read -p "We need to add $dir/bin to your system PATH so that you can access the mxmlc flex compiler globaly. Is this OK with you? [Y|y|N|n]:" -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "Understandable that you don't want to. You may still use the compiler by using an absolute path to the compiler: $dir/bin/mxmlc"
    echo "If you change your mind later, do the following from the command line: echo 'export PATH=\$PATH:'\"$dir/bin\" >> ~/.bashrc"
    exit 1
fi
echo 'export PATH=$PATH:'"$dir/bin" >> ~/.bashrc
source ~/.bashrc
mxmlc --version && echo 'flex compiler installed!' && echo '' && echo "mxmlc --help #to see how to use this compiler or go to http://github.com/aptoma/flex-installer to read some usage scenarios." && exit 0 || echo 'Something went wrong. flex compiler not installed.' && exit 1
