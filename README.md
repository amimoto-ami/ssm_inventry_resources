# AMIMOTO Systems Management documents
Management AMIMOTO AMI instances by EC2 Systems Manager.

## Prepare
You need to setup EC2 Systems Manager Agent into your AMIMOTO Instances.

[Documents](http://docs.aws.amazon.com/systems-manager/latest/userguide/ssm-agent.html#sysman-install-ssm-agent)

## Create documents
You can create SSM docs by cloudformation.
```
$ CURRENT=$(pwd)
$ aws cloudformation create-stack --stack-name YOUR_STACK_NAME  --template-body file:///${CURRENT}/ssm_documents.yml
```

## List created documents
```
$ aws ssm list-documents --document-filter-list key=Name,value=YOUR_STACK_NAME
{
    "DocumentIdentifiers": [
        {
            "Name": "YOUR_STACK_NAME-CustomApplications-XXXXXXXXXXXX",
            "PlatformTypes": [
                "Linux"
            ],
            "DocumentVersion": "1",
            "DocumentType": "Command",
            "Owner": "999999999999",
            "SchemaVersion": "1.2"
        },
        {
            "Name": "YOUR_STACK_NAME-GetAllWpVersion-XXXXXXXXXXXX",
            "PlatformTypes": [
                "Linux"
            ],
            "DocumentVersion": "1",
            "DocumentType": "Command",
            "Owner": "999999999999",
            "SchemaVersion": "1.2"
        },
        {
            "Name": "YOUR_STACK_NAME-ListNginxDomains-XXXXXXXXXXXX",
            "PlatformTypes": [
                "Linux"
            ],
            "DocumentVersion": "1",
            "DocumentType": "Command",
            "Owner": "999999999999",
            "SchemaVersion": "1.2"
        }
    ]
}
```
## Update documents
既存のスタックを更新する場合は `update-stack` を使用します。
```
$ CURRENT=$(pwd)
$ aws cloudformation update-stack --stack-name YOUR_STACK_NAME --template-body file:///${CURRENT}/ssm_documents.yml --region YOUR_REGION
```
### ⚠️ update-stack 後の Association 更新について

`update-stack` を実行すると、SSM Document の物理 ID が変わり新しい Document が再作成されます。そのため、既存の Association は古い Document を参照したままエラーになります。`update-stack` 後は必ず以下の手順で Association を更新してください。

**1. 新しい Document 名を確認**
```
$ aws ssm list-documents \
  --filters Key=Owner,Values=Self \
  --region YOUR_REGION \
  --query "DocumentIdentifiers[?contains(Name,'YOUR_STACK_NAME')].Name" \
  --output table
```
**2. Association を新しい Document 名・スケジュール式で更新**
`--schedule-expression "cron(0 0 1 ? * * *)"` は **WordPressDiskUsageAmount 用の設定例**です。  
他の Association では既存のスケジュールに合わせて変更してください。
```
$ aws ssm update-association \
  --association-id "YOUR_ASSOCIATION_ID" \
  --name "NEW_DOCUMENT_NAME" \
  --association-name "YOUR_ASSOCIATION_NAME" \
  --schedule-expression "cron(0 0 1 ? * * *)" \
  --region YOUR_REGION
```
対象リージョン（CloudFormation スタック `amimoto-managed-inventory-documents` が存在するリージョン）:
- アジアパシフィック (東京) `ap-northeast-1`
- 米国 (オレゴン) `us-west-2`
- 米国 (バージニア北部) `us-east-1`

## Run command example
You need to get Document Name.
Please check `List created documents`.

```
$ aws ssm send-command --instance-ids YOUR_INSTANCE_ID --document-name SSM_DOCUMENTS_NAME
```

## Get Inventry data
After running commannds.
You can get inventry data.
### Get WordPress disk usage amount
```
$ aws ssm list-inventory-entries --instance-id YOUR_INSTANCE_ID --type-name "Custom:WordPressDiskUsageAmount"
```
### Get Nginx SSL domain lists
```
$ aws ssm list-inventory-entries --instance-id YOUR_INSTANCE_ID --type-name "Custom:NginxSSLDomainList"
```
### Get Yum & WP-CLI data
```
$ aws ssm list-inventory-entries --instance-id YOUR_INSTANCE_ID --type-name "Custom:Application"
```
### Get WordPress Data
```
$ aws ssm list-inventory-entries --instance-id YOUR_INSTANCE_ID --type-name "Custom:WordPressInformations"
```
