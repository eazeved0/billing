# Base Variables

ACCOUNTID=`ls -d /files/csvbase/* |awk -F "/" '{print $4}' |awk -F "-" '{print $1}' |tail -n1`
DATE=`date +"%Y-%m"`

echo "Downloading and extracting files from S3..."
#Downloading files
#cd /files/csvswap/
#s3cmd ls s3://detailed-aws-billing-reports |awk -F " " '{print $4}' |while read LINE; do s3cmd get $LINE > /dev/null 2>&1 ; done

#Useless file
#rm aws-programmatic-access-test-object

# Unzip Files
#ls -l *.zip |awk -F " " '{print $9}' |while read ZIP ; do unzip $ZIP > /dev/null 2>&1 ; done

# Removing zip
#rm -rf *.zip

# Okay, time to compare
#perl /files/scripts/compare.pl |grep differ |awk -F " " '{print $4}' > /tmp/diff.lck

# Testing and making the rest
#if [[ -s /tmp/diff.lck ]] ; then

#echo "Found updates on S3! Start to work"
#cat /tmp/diff.lck |while read LINE; do cp $LINE /files/csvdiff/; done

# here import to mysql will be called
#cat /tmp/diff.lck |awk -F "/" '{print $4}' |sed 's/^[0-9]*\W*//' |sed -e "s/[0-9]//g" |sed "s/......$//" |while read LINE; do

newfiles=( `cat /tmp/diff.lck |awk -F "/" '{print $4}'|sed 's/^[0-9]*\W*//'|sed -e "s/[0-9]//g"|sed "s/......$//" `) 

for t in "${newfiles[@]}"
do
echo $t
done

scripts=(` ls -x /files/scripts/ |grep aws `)

for i in "${scripts[@]}"
do
echo $i
done









#if [ $LINE.sh == aws-billing-csv.sh ] ; then

#echo "Importing aws-billing-csv data..."
#sh /files/scripts/aws-billing-csv.sh  /files/csvdiff/$ACCOUNTID-$LINE-$DATE.csv

#else 

#if [ $LINE.sh == aws-billing-detailed-line-items.sh ] ; then

#echo "Importing aws-billing-detailed-line-items data..."
#sh /files/scripts/aws-billing-detailed-line-items.sh  /files/csvdiff/$ACCOUNTID-$LINE-$DATE.csv

#else

#if [ $LINE.sh == aws-billing-detailed-line-items-AWSMarketplace.sh ] ; then

#echo "Importing aws-billing-detailed-line-items-AWSMarketplace data..."
#sh /files/scripts/aws-billing-detailed-line-items-AWSMarketplace.sh  /files/csvdiff/$ACCOUNTID-$LINE-$DATE.csv

#else

#if [ $LINE.sh == aws-billing-detailed-line-items-with-resources-and-tags.sh ] ; then

#echo "Importing aws-billing-detailed-line-items-with-resources-and-tags data..."
#sh /files/scripts/aws-billing-detailed-line-items-with-resources-and-tags.sh /files/csvdiff/$ACCOUNTID-$LINE-$DATE.csv

#else

#if [ $LINE.sh == aws-billing-detailed-line-items-with-resources-and-tags-AWSMarketplace.sh ] ; then

#echo "Importing aws-billing-detailed-line-items-with-resources-and-tags-AWSMarketplace data..."
#sh /files/scripts/aws-billing-detailed-line-items-with-resources-and-tags-AWSMarketplace.sh /files/csvdiff/$ACCOUNTID-$LINE-$DATE.csv

#else

#if [ $LINE.sh == aws-cost-allocation.sh ] ; then

#echo "Importing aws-cost-allocation data..."
#sh /files/scripts/aws-cost-allocation.sh /files/csvdiff/$ACCOUNTID-$LINE-$DATE.csv

#else

#if [ $LINE.sh == aws-cost-allocation-AWSMarketplace.sh ] ; then

#echo "Importing aws-cost-allocation-AWSMarketplace data..."
#sh /files/scripts/aws-cost-allocation-AWSMarketplace.sh /files/csvdiff/$ACCOUNTID-$LINE-$DATE.csv

#else

# echo "Nothing else to do"

#fi
#fi
#fi
#fi
#fi
#fi
#fi

#done

# after executed, if differences, all files from /files/csvswap/ will be moved to /files/csvbase
# then it will be the net 'base'. FILE /tmp/diff.lck MUST be CLEAR!

#echo "Moving new files to base.."
#mv /files/csvdiff/* /files/csvbase/
#echo "Clean up swapdir..."
#rm -f /files/csvswap/*
#echo "Reparing control file.."
#rm /tmp/diff.lck
#touch /tmp/diff.lck


#else

#echo "No new files found on S3. I got nothing to do here"
#rm -f /files/csvswap/*
#if no diff, all will be the same

#fi ;
