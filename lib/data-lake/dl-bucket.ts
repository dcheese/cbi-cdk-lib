
import * as cdk from "aws-cdk-lib";
import { Duration } from "aws-cdk-lib";
import * as s3 from 'aws-cdk-lib/aws-s3'
import * as ssm from 'aws-cdk-lib/aws-ssm'
import { Construct } from "constructs";

interface DataLakeBucketProps extends s3.BucketProps {
    // Prefix for naming the S3 Bucket resources
    ssmPrefix: string;
    // Description of the Buckets purpose/usage.
    description: string;
}

export class DataLakeBucket extends s3.Bucket {
    private _ssmArn: ssm.StringParameter;
    private _ssmName: ssm.StringParameter;

    constructor(scope: Construct, id: string, props: DataLakeBucketProps) {
        super(scope, id);
     
         // Add the bucket NAME and ARN to the parameter store
        this._ssmName = new ssm.StringParameter(this, "BucketName", {
            description: `${props.description} Bucket Name`,
            parameterName: `${props.ssmPrefix}/bucket-name`,
            stringValue: this.bucketName
        })

        this._ssmArn = new ssm.StringParameter(this, "BucketArn", {
            description: `${props.description} Bucket ARN`,
            parameterName: `${props.ssmPrefix}/bucket-arn`,
            stringValue: this.bucketArn
        })
    }
    get ssmArn(): string {
        return this._ssmArn.stringValue;
    }
    get ssmName(): string {
        return this._ssmName.stringValue;
    }
    public setTransition(days: number) {
        this.addLifecycleRule(
            {
                transitions: [
                    {
                        storageClass: s3.StorageClass.INFREQUENT_ACCESS,
                        transitionAfter: cdk.Duration.days(30)
                    }
                ]
            })

    }
    public setExpiration(days: number) {
        this.addLifecycleRule(
            {
                expiration: Duration.days(days)
            })
    }

}
