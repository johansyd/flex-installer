#/bin/bash!
## Documentation source: https://cwiki.apache.org/confluence/display/FLEX/Installation+help#Installationhelp-Ant-basedinstaller
## Latest binaries: http://flex.apache.org/download-binaries.html


set -o nounset
set -o errtrace
set -o errexit
set -o pipefail

# Text color variables
declare -r txtund=$(tput sgr 0 1)          # Underline
declare -r txtbld=$(tput bold)             # Bold
declare -r bldred=${txtbld}$(tput setaf 1) #  red
declare -r bldyellow=${txtbld}$(tput setaf 3) #  red
declare -r bldblu=${txtbld}$(tput setaf 4) #  blue
declare -r bldgreen=${txtbld}$(tput setaf 2) #  blue
declare -r bldwht=${txtbld}$(tput setaf 7) #  white
declare -r txtrst=$(tput sgr0)             # Reset
declare -r isNumber='^[0-9]+$';

function prompt_yes_no () {
    local choice;
    builtin read -p "${bldblu}$1(y/n): ${txtrst}" -r choice;
    case $choice in
        y|Y) echo "yes";;
        n|N) echo "no";;
        *) echo "invalid";;
    esac
}


function say () {
    printf "${bldwht}%b${txtrst}\n" "$*";
}

function fail () {
    printf "${bldred}ERROR: %b${txtrst}\n" "$*";
    exit 1;
}
function warn () {
    printf "${bldyellow}WARN: %b${txtrst}\n" "$*";
}
function example () {
    printf "${bldgreen}%b${txtrst}\n" "$*";
}

function prompt_string () {
    local answer;

    builtin read -p "${bldblu}$1: ${txtrst}" -r answer;
    if [ ! -z "$answer" ]; then
        echo $answer;
        return 0;
    else
        return 1;
    fi
}

function wait_for_keypress () {
    local answer;
    builtin read -n 1 -p "${bldblu}Press any key to continue${txtrst}" -r answer;
}


function open_url () {
    local -r url=$1;
    
    case "$(uname)" in
        Darwin)
            open $1;
            ;;
        Linux)
            BROWSER=${BROWSER:-};
            if [ ! -z "$BROWSER" ]; then
                $BROWSER "$url";
            elif which xdg-open > /dev/null; then
                xdg-open "$url";
            elif which gnome-open > /dev/null; then
                gnome-open "$url";
            else
                fail "Could not detect the web browser to use. Please visit $url manually.";
            fi
            ;;
        *)
            fail "Don't know how to open a browser on this platform. Please visit $url manually.";
            ;;
    esac
}

function abort_not_installed () {
    local -r progname=$1;
    local -r prog_url=$2;

    say "$progname doesn't seem to be installed!";
    local answer=$(prompt_yes_no \
        "Do you want to visit the $progname website to download and install it?");
    [[ $answer == "yes" ]] && open_url $prog_url;
    say "\nTry running this program again after you have installed $progname!";
    exit 2;
}

function abort_too_old () {
    local -r progname=$1;
    local -r prog_url=$2;
    local -r minver=$3;

    say "$progname is too old (need at least $minver)!";
    local answer=$(prompt_yes_no \
        "Do you want to visit the $progname website to upgrade it?");
    [[ $answer == "yes" ]] && open_url $prog_url;
    say "\nTry running this program again after you have upgraded $progname!";
    exit 2;
}


# http://stackoverflow.com/questions/4023830/bash-how-compare-two-strings-in-version-format
vercomp () {
    if [[ $1 == $2 ]]
    then
        return 0
    fi
    local IFS=.
    local i ver1=($1) ver2=($2)
    # fill empty fields in ver1 with zeros
    for ((i=${#ver1[@]}; i<${#ver2[@]}; i++))
    do
        ver1[i]=0
    done
    for ((i=0; i<${#ver1[@]}; i++))
    do
        if [[ -z ${ver2[i]} ]]
        then
            # fill empty fields in ver2 with zeros
            ver2[i]=0
        fi

        if ! [[ ${ver1[i]} =~ $isNumber ]] ; then
               return 3;
        fi

        if ((10#${ver1[i]} > 10#${ver2[i]}))
        then
            return 1
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]}))
        then
            return 2
        fi
    done
    return 0
}

function found () {
    hash $1 2>&-;
}

function javac_is_installed () {
    if found javac; then
        local ver=$(java -version 2>&1 | head -n 1 | sed -E 's/.*"([0-9]+\.[0-9]+\.[0-9]+).*".*$/\1/');
        local -r minver='1.5.0';
        vercomp "$ver" $minver;
        if [ $? == "2" ]; then
            return 0;
        fi
    else
        return 1;
    fi
}

function ant_is_installed () {
    if found ant; then
        local ver=$(ant -version 2>&1 | head -n 1 | sed -E 's/.*([0-9]+\.[0-9]+\.[0-9]+).*$/\1/');
        local -r minver='1.7.0';
        local -r vercomp_status="$(vercomp "$ver" $minver)";
        say "Checking your Ant version number."
        if [ $? == "2" ]; then
            return 0;
        fi
        if [ $? == "3" ]; then
            return 1;
        fi 
    else
        say "Ant is not installed";
        return 1;
    fi
}

function valid_java_install () {
    local -r home="${JAVA_HOME:-}";   

    [ -z $home ] || return 1;
    [ -f $home/lib/tools.jar ] || return 1;
    return 0;
}

function install_ant () {
    if [[ $(prompt_yes_no \
        "
    Apache Ant is not installed and is required. 
    If you want to install Apache Ant system wide answer 'yes' (requires sudo) 
    if not Apache Ant will be installed locally in this folder with your current 
    user as owner. Do you want to install Apache Ant system wide?
    ") == 'yes' ]]
    then
        sudo apt-get install ant
    else
        ant_url='http://apache.rediris.es/ant/binaries/apache-ant-1.9.4-bin.tar.gz'

        [ -f apache-ant-1.9.4-bin.tar.gz ] || wget $ant_url -O apache-ant-1.9.4-bin.tar.gz
        mkdir -p ant-bin;
        [ "$(ls -A ant-bin)" ] || tar -zxf apache-ant-1.9.4-bin.tar.gz -C ant-bin --strip-components=1
        export ANT_OPTS="-Xmx256M"
        export ANT_HOME=$dir/ant-bin
        export PATH=$PATH:$dir/ant-bin/bin
    fi
}

function install_java () {
    if [[ $(prompt_yes_no \
        "
    Java JDK is not installed and is required. 
    If you want to install openjdk-jre system wide answer 'yes' (requires sudo) 
    if not java will be installed for locally in this folder with your current 
    user as owner. Do you want to install java JDK system wide?
    ") == 'yes' ]]
    then
        sudo apt-get install openjdk-7-jdk||sudo apt-get install openjdk-6-jdk||sudo apt-get install openjdk-5-jdk
    else
        java_url='http://download.oracle.com/otn-pub/java/jdk/7/jdk-7-linux-x64.tar.gz';
        [ -f jdk-7-linux-x64.tar.gz ] || wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-se    curebackup-cookie" $java_url -O jdk-7-linux-x64.tar.gz
        mkdir -p jdk7
        [ "$(ls -A jdk7)" ] || tar -zxf jdk-7-linux-x64.tar.gz -C jdk7 --strip-components=1
        export JAVA_HOME=$dir/jdk7
        export PATH=$PATH:$dir/jdk7/bin
    fi
}

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";

if [[ -d apache-flex-sdk-4.12.1-bin && $(prompt_yes_no \
    "
    Everything starting with apache-flex-sdk-4.12.1-bin 
    will be removed from $dir. 
    Is this OK with you?
    ") == 'yes' ]]
then
    rm -rfv $dir/apache-flex-sdk-4.12.1-bin*
else
    warn 'Please rerun this script and choose remove if you get into problems.'
fi

if ! [[ -f apache-flex-sdk-4.12.1-bin.tar.gz ]]; then
    (wget http://apache.uib.no/flex/4.12.1/binaries/apache-flex-sdk-4.12.1-bin.tar.gz -O apache-flex-sdk-4.12.1-bin.tar.gz && say 'flex source downloaded.') || (rm -rf $dir/apache-flex-sdk-4.12.1-bin* && fail 'Something went wrong. flex source not downloaded.')
fi

mkdir -p apache-flex-sdk-4.12.1-bin

if [ -z "$(ls -A apache-flex-sdk-4.12.1-bin)" ]; then
    (tar zxf apache-flex-sdk-4.12.1-bin.tar.gz -C apache-flex-sdk-4.12.1-bin && say 'flex source uncompressed.') || (rm -rf $dir/apache-flex-sdk-4.12.1-bin* && fail 'Something went wrong. flex source not uncompressed.') 
fi


cd $dir/apache-flex-sdk-4.12.1-bin/ && say 'changed directory.'

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";

if ! javac_is_installed
then
    install_java
fi

if ! javac_is_installed
then
    fail 'Could not install java JDK version>=1.5'
fi

if ! valid_java_install
then
    warn "Your java installation has problems. 
Probalby because your JAVA_HOME is wrong or if you installed jre instead of jdk.
Please install our local java and ant version,
or abort this script and correct your JAVA_HOME environment variable 
before running this script again. 
Remember to check that you can run:" 
example "ant -version";
    warn "Rerunning the java installation. Please choose local installation,
or abort, correct your JAVA_HOME environment variable and run this script again.
"
    rm -rf ant-bin
    rm -rf jdk7
    install_java
    install_ant
fi


if ! ant_is_installed
then
    install_ant;
fi

say "Checking if Ant was installed correctly."

if ! ant_is_installed
then
    fail 'Could not install ant version>=1.7'
fi

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";

(ant -f installer.xml -Dair.sdk.version=2.6 && say 'flex binary built.') || (fail 'Something went wrong. flex binary not built.')

mkdir -p $dir/frameworks/libs/player/11.1/ && say 'directory created.'

(wget http://download.macromedia.com/get/flashplayer/updaters/11/playerglobal11_1.swc -O $dir/frameworks/libs/player/11.1/playerglobal.swc && say 'flash player 11.1 downloaded.') || (fail 'Something went wrong. flash player 11.1 not downloaded.')

if [[ $(prompt_yes_no \
    "
    We need to add $dir/bin to your system PATH 
    so that you can access the mxmlc flex compiler globaly. 
    Is this OK with you?
    ") == 'yes' ]]
then
    echo "export JAVA_HOME=$dir/jdk1.7.0_60" >> ~/.bashrc
    echo "export ANT_HOME=$dir/apache-ant-1.9.4" >> ~/.bashrc
    echo "export PATH=$dir/jdk1.7.0_60/bin"':$PATH' >> ~/.bashrc
    echo "export PATH=$dir/apache-ant-1.9.4/bin"':$PATH' >> ~/.bashrc
    echo "export PATH=$dir/bin"':$PATH' >> ~/.bashrc
    say "
flex compiler installed!

To use the flex compiler you need to log out and in of your current terminal or do a "
    example "source ~/.bashrc" 
    say "with your current user to use the compiler at once."
    example "mxmlc -help" 
    say "to see how to use this compiler or go to http://github.com/aptoma/flex-installer 

to read some usage scenarios.

You also installed the component compiler for compiling swc libraries like OSMF."
    example "compc -help"
    exit 0;
else
    say "Understandable that you don't want to. You may still use the compiler by using an absolute path to the compiler: $(dirname $dir)/mxmlc or $(dirname $dir)/compc if you want to use the component compiler to generate swc"
    say "If you change your mind later, do the following from the command line:"
    example "echo 'export PATH=\$PATH:'\"$dir/bin\" >> ~/.bashrc;echo 'export PATH=\$PATH:'\"$dir/jdk1.7.0_60/bin\" >> ~/.bashrc;echo 'export PATH=\$PATH:'\"$dir/apache-ant-1.9.4/bin\" >> ~/.bashrc;echo \"export ANT_HOME=$dir/apache-ant-1.9.4\" >> ~/.bashrc;echo \"export JAVA_HOME=$dir/jdk1.7.0_60\" >> ~/.bashrc"
    # Creating mxml local shell script
    parent=$(dirname $dir)
    echo '#/bin/bash!' > $parent/mxmlc
    echo 'export JAVA_HOME='"$dir/jdk1.7.0_60" >> $parent/mxmlc
    echo 'export ANT_HOME='"$dir/apache-ant-1.9.4" >> $parent/mxmlc
    echo "export PATH=$dir/jdk1.7.0_60/bin"':$PATH' >> $parent/mxmlc
    echo "export PATH=$dir/apache-ant-1.9.4/bin"':$PATH' >> $parent/mxmlc
    echo "export PATH=$dir/bin"':$PATH' >> $parent/mxmlc
    echo "mxmlc "'"$@"' >> $parent/mxmlc
    chmod 711 $parent/mxmlc 
    # Creating compc local shell script
    echo '#/bin/bash!' > $parent/compc
    echo 'export JAVA_HOME='"$dir/jdk1.7.0_60" >> $parent/compc
    echo 'export ANT_HOME='"$dir/apache-ant-1.9.4" >> $parent/compc
    echo "export PATH=$dir/jdk1.7.0_60/bin"':$PATH' >> $parent/compc
    echo "export PATH=$dir/apache-ant-1.9.4/bin"':$PATH' >> $parent/compc
    echo "export PATH=$dir/bin"':$PATH' >> $parent/compc
    echo "compc "'"$@"' >> $parent/compc
    chmod 711 $parent/compc
fi

exit 0;
