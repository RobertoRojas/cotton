#!/bin/env bash
function execute {
    [ $COTTON_EXECUTE != TRUE ] && return;
    [ "$1" == 'help' ] && echo 'To do' && return;
    EXECUTE_PATH=`[[ -f "$1" ]] && echo $1 || echo "./.cotton_execute"`;
    if [[ -f $EXECUTE_PATH ]]
    then
        [ "$1" == 'clear' ] && clear;
        source $EXECUTE_PATH
    else
        echo 'Nothing to execute';
    fi
}
function cd {
    if [ $COTTON_CD != TRUE ]
    then
        builtin cd $*;
        return $?;
    fi
    CD_PATH='./.cotton_cd';
    if [[ -f $CD_PATH ]]
    then
        source $CD_PATH 'goingout';
    fi
    builtin cd $@;
    EXIT_CODE=$?;
    if [[ -f $CD_PATH ]]
    then
        source $CD_PATH 'goingin';
    fi
    return $EXIT_CODE;
}
function cotton {
    if [ "$1" == 'cd' ]
    then
        [ "$2" == 'help' ] && echo -e 'To do' && return;
        CD_PATH='./.cotton_cd';
        if [ -f $CD_PATH ]
        then
            echo "The cd file[$CD_PATH] already exists" >&2;
            return 1;
        fi
        if [ "$2" == 'executable' ]
        then
            CD_CONTENT="CACHE_PATH='./.cotton_cd_executable';\nEXECUTABLE='';\nCHANGE_PATH='';\nEXECUTABLE_ALIAS=\`alias \$EXECUTABLE 2>/dev/null\`;\nif [ -z \$EXECUTABLE ] || [ -z \$CHANGE_PATH ]\nthen\n\techo 'Cannot proceed, EXECUTABLE or EXECUTABLE_ALIAS is empty' >&2;\nelif [ \$1 == 'goingin' ]\nthen\n\tif [ ! -z \"\$EXECUTABLE_ALIAS\" ]\n\tthen\n\t\techo \$EXECUTABLE_ALIAS > \$CACHE_PATH;\n\tfi\n\talias \$EXECUTABLE=\$CHANGE_PATH;\nelif [ \$1 == 'goingout' ]\nthen\n\tif [ ! -z \"\$EXECUTABLE_ALIAS\" ]\n\tthen\n\t\tunalias \$EXECUTABLE;\n\tfi\n\tif [[ -f \$CACHE_PATH ]]\n\tthen\n\t\tsource \$CACHE_PATH;\n\t\trm \$CACHE_PATH;\n\tfi\nfi";
        elif [ "$2" == 'python_environment' ]
        then
            CD_CONTENT="ACTIVATE_PATH='';\nif [ \"\$1\" == 'goingin' ]\nthen\n\tif [[ -f \$ACTIVATE_PATH ]]\n\tthen\n\t\tsource \$ACTIVATE_PATH;\n\tfi\nelif [ \"\$1\" == 'goingout' ]\nthen\n\tdeclare -f -F deactivate > /dev/null && deactivate;\nfi";
        elif [ "$2" == 'path' ]
        then
            CD_CONTENT="CACHE_PATH='./.cotton_cd_path';\nif [ \$1 == 'goingin' ]\nthen\n\tPATH_TO_ADD='';\n\techo \$PATH > \$CACHE_PATH;\n\tPATH=\"\$PATH:\$PATH_TO_ADD\";\nelif [ \$1 == 'goingout' ]\nthen\n\tif [[ ! -f \$CACHE_PATH ]]\n\tthen\n\t\techo \"Cannot find the backup file[\$CACHE_PATH], cannot restore the path\" >&2;\n\telse\n\t\tPATH=\`cat \$CACHE_PATH\`;\n\t\trm \$CACHE_PATH;\n\tfi\nfi";
        else
            CD_CONTENT="if [ \"\$1\" == 'goingin' ]\nthen\n\techo 'going in';\nelif [ \"\$1\" == 'goingout' ]\nthen\n\techo 'going out';\nfi";
        fi
        echo -e $CD_CONTENT > $CD_PATH;
    elif [ "$1" == 'execute' ]
    then
        [ "$2" == 'help' ] && echo -e 'execute -> Create the execute file, it creates it in the current directory if any is specified' && return;
        EXECUTE_PATH="./.cotton_execute";
        if [ -f $EXECUTE_PATH ]
        then
            echo "The execute file[$EXECUTE_PATH] already exists" >&2;
            return 1;
        else
            echo "echo 'COTTON EXECUTE'" > $EXECUTE_PATH;
        fi
    elif [ "$1" == 'info' ]
    then
        [ "$2" == 'help' ] && echo -e 'info -> Display the information about cotton' && return;
        echo 'Repository: https://github.com/RobertoRojas/cotton';
        echo 'Author: Roberto Rojas';
    elif [ "$1" == 'info' ]
    then
        [ "$2" == 'help' ] && echo -e 'version -> Display the version of cotton' && return;
        echo "cotton v$COTTON_VERSION";
    else
        echo -e '\ncotton OPTION [help]';
        echo -e '\nOptions:\n';
        declare -a OPTIONS=(
            'info'
            'version'
            'execute'
        );
        for o in "${OPTIONS[@]}"
        do
            cotton $o help;
        done
        for o in "${OPTIONS[@]:2}"
        do
            $o help;
        done
    fi
}
export COTTON_VERSION=1.0;
export COTTON_EXECUTE=TRUE;
export COTTON_CD=TRUE;