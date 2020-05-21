#!/usr/bin/env bash
hello=!{x}
output=!{output}
previous_file=!{previous_file}
cat ${previous_file} > $output
echo "${hello} world!" >> $output
