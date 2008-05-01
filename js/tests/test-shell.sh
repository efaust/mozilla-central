#!/bin/bash -e
# -*- Mode: Shell-script; tab-width: 4; indent-tabs-mode: nil; -*-

# ***** BEGIN LICENSE BLOCK *****
# Version: MPL 1.1/GPL 2.0/LGPL 2.1
#
# The contents of this file are subject to the Mozilla Public License Version
# 1.1 (the "License"); you may not use this file except in compliance with
# the License. You may obtain a copy of the License at
# http://www.mozilla.org/MPL/
#
# Software distributed under the License is distributed on an "AS IS" basis,
# WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
# for the specific language governing rights and limitations under the
# License.
#
# The Original Code is Mozilla JavaScript Testing Utilities
#
# The Initial Developer of the Original Code is
# Mozilla Corporation.
# Portions created by the Initial Developer are Copyright (C) 2007
# the Initial Developer. All Rights Reserved.
#
# Contributor(s): Bob Clary <bclary@bclary.com>
#
# Alternatively, the contents of this file may be used under the terms of
# either the GNU General Public License Version 2 or later (the "GPL"), or
# the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
# in which case the provisions of the GPL or the LGPL are applicable instead
# of those above. If you wish to allow use of your version of this file only
# under the terms of either the GPL or the LGPL, and not to allow others to
# use your version of this file under the terms of the MPL, indicate your
# decision by deleting the provisions above and replace them with the notice
# and other provisions required by the GPL or the LGPL. If you do not delete
# the provisions above, a recipient may use your version of this file under
# the terms of any one of the MPL, the GPL or the LGPL.
#
# ***** END LICENSE BLOCK *****

if [[ -z "$TEST_DIR" ]]; then
    cat <<EOF
`basename $0`: error

TEST_DIR, the location of the Sisyphus framework, 
is required to be set prior to calling this script.
EOF
    exit 2
fi

if [[ ! -e $TEST_DIR/bin/library.sh ]]; then
    echo "TEST_DIR=$TEST_DIR"
    echo ""
    echo "This script requires the Sisyphus testing framework. Please "
    echo "cvs check out the Sisyphys framework from mozilla/testing/sisyphus"
    echo "and set the environment variable TEST_DIR to the directory where it"
    echo "located."
    echo ""

    exit 2
fi

source $TEST_DIR/bin/library.sh

TEST_JSDIR=`dirname $0`
TEST_JSSHELL_TIMEOUT=${TEST_JSSHELL_TIMEOUT:-480}

#
# options processing
#
usage()
{
    cat <<EOF
usage: $SCRIPT -b branch -s sourcepath -T buildtype [-d datafiles]

variable            description
===============     ===========================================================
-p product          required. js
-b branch           required. 1.8.0|1.8.1|1.9.0
-s sourcepath       required. path to js shell source directory mozilla/js/src
-T buildtype        required. one of opt debug
-X excludetests     optional. By default the test will exclude the 
                    tests listed in spidermonkey-n-\$branch.tests, 
                    performance-\$branch.tests. excludetests is a list of either
                    individual tests, manifest files or sub-directories which 
                    will override the default exclusion list.
-I includetests     optional. By default the test will include the 
                    JavaScript tests appropriate for the branch. includetests is a
                    list of either individual tests, manifest files or 
                    sub-directories which will override the default inclusion 
                    list.
-Z n                optional. Set gczeal to n. Currently, only valid for 
                    Gecko 1.9.0 and later.
-c                  optional. By default the test will exclude tests 
                    which crash on this branch, test type, build type and 
                    operating system. -c will include tests which crash. 
                    Typically this should only be used in combination with -R. 
                    This has no effect on shell based tests which execute crash
                    tests regardless.
-t                  optional. By default the test will exclude tests 
                    which time out on this branch, test type, build type and 
                    operating system. -t will include tests which timeout.
-d datafiles        optional. one or more filenames of files containing 
                    environment variable definitions to be included.

EOF
    exit 2
}

while getopts "b:s:T:d:X:I:Z:ct" optname
do 
    case $optname in
        b) branch=$OPTARG;;
        s) sourcepath=$OPTARG;;
        T) buildtype=$OPTARG;;
        X) excludetests=$OPTARG;;
        I) includetests=$OPTARG;;
        C) crashes=1;;
        T) timeouts=1;;
        Z) gczeal="-Z $OPTARG";;
        d) datafiles=$OPTARG;;
    esac
done

# include environment variables
if [[ -n "$datafiles" ]]; then
    for datafile in $datafiles; do 
        source $datafile
    done
fi

dumpvars branch sourcepath buildtype excludetests includetests crashes timeouts gczeal datafiles | sed "s|^|arguments: |"

if [[ -z "$branch" || -z "$sourcepath" || -z "$buildtype" ]]; then
    usage
fi

pushd $TEST_JSDIR

rm -f finished-$branch-shell-$buildtype

. config.sh

executable="$sourcepath/$JS_OBJDIR/js$EXE_EXT"

if ! make failures.txt; then
    error "during make failures.txt" $LINENO
fi

#includetestsfile=`mktemp includetestsfile.XXXXX`
includetestsfile="included-$branch-shell-$buildtype.tests"
rm -f $includetestsfile
touch $includetestsfile

if [[ -z "$includetests" ]]; then

    # by default include tests appropriate for the branch
    includetests="e4x ecma ecma_2 ecma_3 js1_1 js1_2 js1_3 js1_4 js1_5 js1_6"

    case "$branch" in 
        1.8.0)
            ;;
        1.8.1)
            includetests="$includetests js1_7"
            ;;
        1.9.0)
            includetests="$includetests js1_7 js1_8"
            ;;
    esac
fi

for i in $includetests; do
    if [[ -f "$i" ]]; then
        echo "# including $i" >> $includetestsfile
        if echo $i | grep -q '\.js$'; then
            echo $i >> $includetestsfile
        else
            cat $i >> $includetestsfile
        fi
    elif [[ -d "$i" ]]; then
        find $i -name '*.js' -print | egrep -v '(shell|browser|template|jsref|userhook.*|\.#.*)\.js' | sed 's/^\.\///' | sort >> $includetestsfile
    fi
done

#excludetestsfile=`mktemp excludetestsfile.XXXXX`
excludetestsfile="excluded-$branch-shell-$buildtype.tests"
rm -f $excludetestsfile
touch $excludetestsfile

if [[ -z "$excludetests" ]]; then
    excludetests="spidermonkey-n-$branch.tests performance-$branch.tests"
fi

for e in $excludetests; do
    if [[ -f "$e" ]]; then
        echo "# excluding $e" >> $excludetestsfile
        if echo $e | grep -q '\.js$'; then
            echo $e >> $excludetestsfile
        else
            cat $e >> $excludetestsfile
        fi
    elif [[ -d "$e" ]]; then
        find $e -name '*.js' -print | egrep -v '(shell|browser|template|userhook.*|\.#.*).js' | sed 's/^\.\///' | sort >> $excludetestsfile
    fi
done

case "$OSID" in
    win32)
        arch='.*'
        kernel='.*'
        ;;
    linux)
        arch="`uname -p`"
        kernel="`uname -r | sed 's|\([0-9]*\)\.\([0-9]*\)\.\([0-9]*\)[-.0-9]*\.\([a-zA-Z0-9]*\)|\1.\2.\3.*\4|'`"
        ;;
    mac)
        arch="`uname -p`"
        kernel='[^,]*'
        ;;
    *)
        error "$product-$branch-$buildtype: $OSID not supported" $LINENO
        ;;
esac

if [[ -z "$timeouts" ]]; then
    echo "# exclude tests that time out" >> $excludetestsfile
    egrep "TEST_BRANCH=([^,]*$branch[^,]*|[.][*]), TEST_RESULT=FAILED, TEST_BUILDTYPE=([^,]*$buildtype[^,]*|[.][*]), TEST_TYPE=([^,]*shell[^,]*|[.][*]), TEST_OS=([^,]*$OSID[^,]*|[.][*]), .*, TEST_PROCESSORTYPE=([^,]*$arch[^,]*|[.][*]), TEST_KERNEL=([^,]*$kernel[^,]*|[.][*]), .*, TEST_DESCRIPTION=.*EXIT STATUS: TIMED OUT" \
        failures.txt  | sed 's/TEST_ID=\([^,]*\),.*/\1/' | sort | uniq >> $excludetestsfile
fi

if [[ -z "$crashes" ]]; then
    echo "# exclude tests that crash" >> $excludetestsfile
    pattern="TEST_BRANCH=([^,]*$branch[^,]*|[.][*]), TEST_RESULT=FAILED, TEST_BUILDTYPE=([^,]*$buildtype[^,]*|[.][*]), TEST_TYPE=([^,]*shell[^,]*|[.][*]), TEST_OS=([^,]*$OSID[^,]*|[.][*]), .*, TEST_PROCESSORTYPE=([^,]*$arch[^,]*|[.][*]), TEST_KERNEL=([^,]*$kernel[^,]*|[.][*]), .*, TEST_DESCRIPTION=.*"
    case "$buildtype" in
        opt)
            pattern="${pattern}EXIT STATUS: CRASHED"
            ;;
        debug)
            pattern="${pattern}(EXIT STATUS: CRASHED|Assertion failure:)"
            ;;
    esac
    egrep "$pattern" failures.txt  | sed 's/TEST_ID=\([^,]*\),.*/\1/' | sort | uniq >> $excludetestsfile

fi

cat $includetestsfile | sed 's|^|include: |'
cat $excludetestsfile | sed 's|^|exclude: |'

if ! time perl jsDriver.pl \
    -l $includetestsfile \
    -L $excludetestsfile \
    -s $executable \
    -e sm$buildtype \
    -o "-S 524288 $gczeal" \
    -R \
    -T $TEST_JSSHELL_TIMEOUT \
    -f /dev/null \
    -Q; then
    error "$product-$branch-$buildtype-$OSID: jsDriver.pl" $LINENO
fi

popd
