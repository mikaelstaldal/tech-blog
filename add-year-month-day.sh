#/bin/bash

for file in `ls -1 |grep '^[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]-'`; do
  year=`echo ${file} | sed 's|\([0-9][0-9][0-9][0-9]\)-\([0-9][0-9]\)-\([0-9][0-9]\)-.*|\1|g'`
  month=`echo ${file} | sed 's|\([0-9][0-9][0-9][0-9]\)-\([0-9][0-9]\)-\([0-9][0-9]\)-.*|\1/\2|g'`
  day=`echo ${file} | sed 's|\([0-9][0-9][0-9][0-9]\)-\([0-9][0-9]\)-\([0-9][0-9]\)-.*|\1/\2/\3|g'`
  sed -i -e "1d" ${file}
  sed -i -e "1i day: ${day}" ${file}
  sed -i -e "1i month: ${month}" ${file}
  sed -i -e "1i year: ${year}" ${file}
  sed -i -e "1i ---" ${file}
done
