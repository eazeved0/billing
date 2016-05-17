#!/bin/bash
#
# Please read "/files/aws-billing-csv.sh" to get information regarding this script workflow.
#
ACCOUNTID=`echo $1 |awk -F "/" '{print $4}' |awk -F "-" '{print $1}' |tail -n1`
DATE=`echo $1 |awk -F "/" '{print $4}' | rev |awk -F "-" '{print $1 $2}' |awk -F "." '{print $2}' |rev`
IMPORTDATE=`date +"%Y%m%d"`

SQLOUT=`/usr/bin/mysql -h aximbillingdb.c178w1ceq84e.us-east-1.rds.amazonaws.com cloud_billing_db -e "

LOAD DATA LOCAL INFILE '$1'
INTO TABLE aws_billing_detailed_line_items_AWSMarketplace 
FIELDS TERMINATED BY ','
ENCLOSED BY '\"'
IGNORE 1 LINES
(invoice_i_d,payer_account_id,linked_account_id,record_type,product_name,rate_id,subscription_id,pricing_plan_id,usage_type,operation,availability_zone,reserved_instance,item_description,usage_start_date,usage_end_date,usage_quantity,rate,cost,UnBlendedRate,UnBlendedCost) SET month_ = $DATE, account_ = $ACCOUNTID, imported_date = $IMPORTDATE ;"  -e "SELECT ROW_COUNT();"`

SQLCOUNT=`echo $SQLOUT | sed 's/[^0-9]*//g'`
echo "$SQLCOUNT Rows Imported"

# Comparing csv File
CVSOUT=`tail -n +2 $1 |wc |awk -F " " '{print $1}'`

if [ $SQLCOUNT -eq $CVSOUT ]
then
        echo "CSV file $1 imported sucessfully"
else
        echo "Failed to import CSV file $1"
fi
