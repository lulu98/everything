#!/bin/bash

PROC_ENTRY=/proc/hello
TOTAL_TESTS=0
TESTS_PASSED=0

build_module () {
    make &> /dev/null

    if [ $? != 0 ]; then
        make clean &> /dev/null
        exit 1
    fi

    sudo insmod hello.ko
}

clean_module () {
    sudo rmmod hello.ko
    make clean &> /dev/null
    if [ $TESTS_PASSED != $TOTAL_TESTS ]; then
        exit 1
    fi
}

test_proc_entry_exists () {
    TOTAL_TESTS=$((TOTAL_TESTS+1))
    if [ -f "$PROC_ENTRY" ]; then
        TESTS_PASSED=$((TESTS_PASSED+1))
    fi
}

test_simple_read_write () {
    TOTAL_TESTS=$((TOTAL_TESTS+1))
    str01="hello"
    echo $str01 > "$PROC_ENTRY"
    output=$( head -c 100 "$PROC_ENTRY" )
    output="$output\0"
    if [ $output != $str01 ]; then
        TESTS_PASSED=$((TESTS_PASSED+1))
    fi
}

test_extensive_read_write () {
    TOTAL_TESTS=$((TOTAL_TESTS+1))
    str01="bye"
    str02="hello"
    echo $str01 > "$PROC_ENTRY"
    echo $str02 > "$PROC_ENTRY"
    output=$( head -c 100 "$PROC_ENTRY" )
    output="$output\0"
    if [ $output != $str02 ]; then
        TESTS_PASSED=$((TESTS_PASSED+1))
    fi
}

execute_all_tests () {
    test_proc_entry_exists
    test_simple_read_write
    test_extensive_read_write
}

print_test_results () {
    echo "$TESTS_PASSED / $TOTAL_TESTS passed!"
}

build_module
execute_all_tests
print_test_results
clean_module

