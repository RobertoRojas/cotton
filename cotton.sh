#!/bin/env bash

function execute {
    [ $COTTON_EXECUTE != TRUE ] && return 0;
    if [ "$1" == 'help' ]
    then
        echo 'This function run the content of .cotton_execute into the current folder, command:';
        echo '';
        echo 'execute [clear|help] <path>';
        echo '';
        echo 'Arguments:';
        echo '';
        echo '- help: Shows the help of the command';
        echo '- clear: Clear the shell before execute .cotton_execute';
        return 0;
    fi
    EXECUTE_CLEAR=FALSE;
    if [ "$1" == 'clear' ]
    then
        EXECUTE_CLEAR=TRUE;
        shift;
    fi
    EXECUTE_PATH=`[[ -f "$1" ]] && echo $1 || echo "./.cotton_execute"`;
    if [[ -f $EXECUTE_PATH ]]
    then
        [ $EXECUTE_CLEAR == TRUE ] && clear;
        source $EXECUTE_PATH;
    else
        echo 'Nothing to execute';
    fi
    unset EXECUTE_PATH;
    unset EXECUTE_CLEAR;
}
function cd {
    if [ $COTTON_CD != TRUE ]
    then
        builtin cd $*;
        return $?;
    fi
    if [ "$1" == 'help' ]
    then
        echo 'This function overwrite the behavior of the cd command to add the execution of something when entering or exiting a folder with .cotton cd, command:';
        echo '';
        echo 'cd [help]';
        echo '';
        echo 'Arguments:';
        echo '';
        echo '- help: Shows the help of the command';
        return 0;
    fi
    CD_PATH='./.cotton_cd';
    if [[ -f $CD_PATH ]]
    then
        source $CD_PATH 'goingout';
    fi
    builtin cd $@;
    CD_EXIT_CODE=$?;
    if [[ -f $CD_PATH ]]
    then
        source $CD_PATH 'goingin';
    fi
    unset $CD_PATH;
    return $CD_EXIT_CODE;
}
function cotton {
    if [ "$1" == 'cd' ]
    then
        if [ "$2" == 'help' ]
        then
            echo 'This command create a template to use with the cd function, command:';
            echo '';
            echo 'cotton cd <executable|python_environment|path>';
            echo '';
            echo 'Options:';
            echo '';
            echo 'executable: This template is useful to overwrite an executable with other';
            echo 'python_environment: This template is usefull to activate/deactivate a pyhton environmemt';
            echo 'path: Add something to the shell PATH';
            echo '';
            echo "if you don't send anything, it create a simple file with in/out conditionals";
            return 0;
        fi
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
        unset CD_CONTENT;
        unset CD_PATH;
    elif [ "$1" == 'execute' ]
    then
        if [ "$2" == 'help' ]
        then 
            echo 'This command create a template to use with the execute function, command:';
            echo '';
            echo 'cotton execute';
            return 0;
        fi
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
        if [ "$2" == 'help' ]
        then 
            echo 'Display the information about cotton, command:';
            echo '';
            echo 'cotton info';
            return 0;
        fi 
        echo 'Repository: https://github.com/RobertoRojas/cotton';
        echo 'Author: Roberto Rojas';
    elif [ "$1" == 'info' ]
    then
        if [ "$2" == 'help' ]
        then 
            echo 'Display the version of cotton, command:';
            echo '';
            echo 'cotton info';
            return 0;
        fi
        echo "cotton v$COTTON_VERSION";
    else
        echo 'Cotton create templates or display information, command: ';
        echo '';
        echo 'cotton <option> [help]';
        echo '';
        echo 'Options: ';
        echo '';
        declare -a OPTIONS=(
            'info'
            'version'
            'execute'
            'cd'
        );
        for o in "${OPTIONS[@]}"
        do
            echo "- $o";
        done
        echo '';
        echo 'You can get more  information about how to use, command:';
        echo '';
        echo '<command> help';
        echo '';
        echo 'Commands';
        echo '';
        for o in "${OPTIONS[@]:2}"
        do
            echo "- $o";
        done
        echo '';
        echo 'You can deactivate any command, changing the value of an environemt variable from TRUE to FALSE, variable:';
        echo '';
        echo 'COTTON_<command>';
        echo '';
        echo 'Variables:';
        echo '';
        for o in "${OPTIONS[@]:2}"
        do
            echo "- COTTON_${o^^}";
        done
    fi
}
export COTTON_VERSION=1.0;
export COTTON_EXECUTE=TRUE;
export COTTON_CD=TRUE;