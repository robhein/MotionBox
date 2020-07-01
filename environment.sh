#!/bin/sh
set -e

#--------------------------------------------------------------------------------------------------
# Settings
#--------------------------------------------------------------------------------------------------

Sky="../Sky"

#--------------------------------------------------------------------------------------------------

compiler_win="mingw"

qt="qt5"

#--------------------------------------------------------------------------------------------------
# Functions
#--------------------------------------------------------------------------------------------------

replace()
{
    expression='s/'"$1"'=\"'"$2"'"/'"$1"'=\"'"$3"'"/g'

    apply $expression environment.sh

    apply $expression configure.sh
    apply $expression build.sh
    apply $expression deploy.sh

    apply $expression content/generate.sh
}

apply()
{
    if [ $host = "macOS" ]; then

        sed -i "" $1 $2
    else
        sed -i $1 $2
    fi
}

#--------------------------------------------------------------------------------------------------

getOs()
{
    case `uname` in
    Darwin*) echo "macOS";;
    *)       echo "other";;
    esac
}


#--------------------------------------------------------------------------------------------------
# Syntax
#--------------------------------------------------------------------------------------------------

if [ $# != 2 -a $# != 3 ] \
   || \
   [ $1 != "mingw" -a $1 != "msvc" ] || [ $2 != "qt4" -a $2 != "qt5" ] \
   || \
   [ $# = 3 -a "$3" != "all" ]; then

    echo "Usage: environment <mingw | msvc> <qt4 | qt5> [all]"

    exit 1
fi

#--------------------------------------------------------------------------------------------------
# Configuration
#--------------------------------------------------------------------------------------------------

host=$(getOs)

#--------------------------------------------------------------------------------------------------
# Sky
#--------------------------------------------------------------------------------------------------

if [ "$3" = "all" ]; then

    echo "ENVIRONMENT Sky"
    echo "---------------"

    cd "$Sky"

    sh environment.sh $1 $2

    cd -

    echo "---------------"
    echo ""
fi

#--------------------------------------------------------------------------------------------------
# Replacements
#--------------------------------------------------------------------------------------------------

if [ $1 = "msvc" ]; then

    replace compiler_win $compiler_win msvc
else
    replace compiler_win $compiler_win mingw
fi

replace qt $qt $2
