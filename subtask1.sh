#!/bin/bash


for arg in "$@"
do
 index=$(echo $arg | cut -f1 -d=)
 val=$(echo $arg | cut -f2 -d=)
 case $index in
  -file) file=$val;;
  -workers) workers=$val;;
  -column) column=$val;;
  -folder) folder=$val;;
  *)
 esac
done


if [ -z "$file" ]
then
  echo "No file"
  exit 1
else
  echo $file
  #echo "file"
fi

if [ -z "$workers" ]
then
  echo "No workers number"
  exit 1
else
  echo "workers number"
fi

if [ -z "$column" ]
then
  echo "No column"
  exit 1
else
  echo "column"
fi

if [ -z "$folder" ]
then
  echo "No folder"
  exit 1
else
  echo "folder"
fi


index=$(head --lines 1 $file | tr ';' '\n' | nl |grep -w "$column" | tr -d " " | awk -F " " '{print $1}')

if [ -z "$index" ]
then
  echo "no column name"
  exit 1
fi


links=( $(tail -n +2 $file | cut -d ';' -f${index}) )

parallel -j $workers --progress wget {} -q -P $folder ::: "${links[@]}"
