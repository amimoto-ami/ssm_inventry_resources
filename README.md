# AMIMOTO Systems Management documents
Management AMIMOTO AMI instances by EC2 Systems Manager.

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
            "Owner": "213144662080",
            "SchemaVersion": "1.2"
        },
        {
            "Name": "YOUR_STACK_NAME-GetAllWpVersion-XXXXXXXXXXXX",
            "PlatformTypes": [
                "Linux"
            ],
            "DocumentVersion": "1",
            "DocumentType": "Command",
            "Owner": "213144662080",
            "SchemaVersion": "1.2"
        },
        {
            "Name": "YOUR_STACK_NAME-ListNginxDomains-XXXXXXXXXXXX",
            "PlatformTypes": [
                "Linux"
            ],
            "DocumentVersion": "1",
            "DocumentType": "Command",
            "Owner": "213144662080",
            "SchemaVersion": "1.2"
        }
    ]
}
```

## Run command example
You need to get Document Name.
Please check `List created documents`.

```
$ aws ssm send-command --instance-ids YOUR_INSTANCE_ID --document-name SSM_DOCUMENTS_NAME
```

## Get Inventry data
After running commannds.
You can get inventry data.
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
