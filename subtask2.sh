#!/bin/bash


for arg in "$@"
do
 index=$(echo $arg | cut -f1 -d=)
 val=$(echo $arg | cut -f2 -d=)
 case $index in
  -input) file=$val;;
  -train_ratio) train_ratio=$val;;
  -train_file) train_file=$val;;
  --test_file) test_file=$val;;
  -y_column) column=$val;;
  *)
 esac
done


if [ -z "$file" ]
then
  echo "No file"
  exit 1
else 
  echo "Ok file"
fi

if [ -z "$train_ratio" ]
then
  echo "No percent"
  exit 1
else 
  echo "Ok percent"
fi

if [ -z "$train_file" ]
then
  echo "No train file"
  exit 1
else 
  echo "Ok train file"
fi

if [ -z "$test_file" ]
then
  echo "No test file"
  exit 1
else 
  echo "Ok test file"
fi

if [ -z "$column" ]
then
  echo "No column"
  exit 1
else 
  echo "Ok column"
fi


column_index=$(head --lines 1 $file | tr ';' '\n' | nl |grep -w "$column" | tr -d " " | awk -F " " '{print $1}')

if [ -z "$column_index" ]
then
  echo "No column name"
  exit 1
fi

lines_count=$(($(< $file wc -l)-1))

train_lines_count=$(echo "$lines_count * $train_ratio/1" | bc)

head -$((train_lines_count+1)) $file | tail -$train_lines_count > $train_file
tail -$((lines_count-train_lines_count)) $file > $test_file
