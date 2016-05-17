# Base Variables

ACCOUNTID=`ls -d /files/csvbase/* |awk -F "/" '{print $4}' |awk -F "-" '{print $1}' |tail -n1`
DATE=`date +"%Y-%m"`
FULLDATE=`date +"%Y-%m-%d"`
BACKUPDIR=/files/backups/csvfiles/$FULLDATE

echo "Downloading and extracting files from S3..."

cd /files/csv_new/

/files/scripts/s3_list.py |grep -v program |grep `date +%Y-%m-%d` |awk -F " " '{print $1}' |while read LINE; do /usr/local/bin/s3cmd get s3://detailed-aws-billing-reports/$LINE > /dev/null 2>&1 ; done

# Unzip Files
ls -l *.zip |awk -F " " '{print $9}' |while read ZIP ; do unzip $ZIP > /dev/null 2>&1 ; done

# Removing zip
rm -rf *.zip > /dev/null 2>&1

if [ $(find /files/csv_new/ -maxdepth 0 -type d -empty 2>/dev/null) ]; then
    echo "No new files found on S3. Exiting now."

exit 0

else

echo "Found new files on S3!"
ls -ld /files/csv_new/* |awk -F " " '{print $9}' > /tmp/files.lst
cp /files/csv_new/* /files/csv_import/
echo "Importing these files:"
cat /tmp/files.lst

# here import to mysql will be called

echo "Importing to RDS..."
cat /tmp/files.lst |awk -F "/" '{print $4}' |sed 's/^[0-9]*\W*//' |sed -e "s/[0-9]//g" |sed "s/......$//" |while read LINE; do

if [ $LINE.sh == aws-billing-csv.sh ] ; then

echo "Importing aws-billing-csv data..."
sh /files/scripts/aws-billing-csv.sh  /files/csv_import/$ACCOUNTID-$LINE-*.csv

else 

if [ $LINE.sh == aws-billing-detailed-line-items.sh ] ; then

echo "Importing aws-billing-detailed-line-items data..."
sh /files/scripts/aws-billing-detailed-line-items.sh  /files/csv_import/$ACCOUNTID-$LINE-*.csv

else

if [ $LINE.sh == aws-billing-detailed-line-items-AWSMarketplace.sh ] ; then

echo "Importing aws-billing-detailed-line-items-AWSMarketplace data..."
sh /files/scripts/aws-billing-detailed-line-items-AWSMarketplace.sh  /files/csv_import/$ACCOUNTID-$LINE-*.csv

else

if [ $LINE.sh == aws-billing-detailed-line-items-with-resources-and-tags.sh ] ; then

echo "Importing aws-billing-detailed-line-items-with-resources-and-tags data..."
sh /files/scripts/aws-billing-detailed-line-items-with-resources-and-tags.sh /files/csv_import/$ACCOUNTID-$LINE-*.csv

else

if [ $LINE.sh == aws-billing-detailed-line-items-with-resources-and-tags-AWSMarketplace.sh ] ; then

echo "Importing aws-billing-detailed-line-items-with-resources-and-tags-AWSMarketplace data..."
sh /files/scripts/aws-billing-detailed-line-items-with-resources-and-tags-AWSMarketplace.sh /files/csv_import/$ACCOUNTID-$LINE-*.csv

else

if [ $LINE.sh == aws-cost-allocation.sh ] ; then

echo "Importing aws-cost-allocation data..."
sh /files/scripts/aws-cost-allocation.sh /files/csv_import/$ACCOUNTID-$LINE-*.csv

else

if [ $LINE.sh == aws-cost-allocation-AWSMarketplace.sh ] ; then

echo "Importing aws-cost-allocation-AWSMarketplace data..."
sh /files/scripts/aws-cost-allocation-AWSMarketplace.sh /files/csv_import/$ACCOUNTID-$LINE-*.csv

else

 echo "Nothing else to do"

fi
fi
fi
fi
fi
fi
fi

done

fi

# Backuping the imported files

echo "Creating tar file of imported files..."
if [ ! -d "$BACKUPDIR" ]
then
    mkdir $BACKUPDIR
else
    echo "Dir exists"
fi

tar -zcf $BACKUPDIR/imported_csvfiles.tar.gz /files/csv_import > /dev/null 2>&1 
# Cleaning up files backup olders than 30 days
find $BACKUPDIR/* -mtime +30 -exec rm -rf {} \;

echo "Moving new files to permanent base.."
mv /files/csv_import/* /files/csvbase/

echo "Clean up swapdir..."
rm -f /files/csv_new/*
echo "Clean up Diff dir..."
rm -f /files/csv_import/*
echo "Reparing control file..."
rm /tmp/files.lst
touch /tmp/files.lst
