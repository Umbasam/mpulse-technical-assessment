import os
import boto3

ec2 = boto3.client('ec2')

def lambda_handler(event, context):
    # Need to capture 2 things: instance id, action (stop/start)
    schedule_action = os.environ['SCHEDULER_ACTION']
    instance_id = os.environ['INSTANCE_ID']

    if schedule_action == "ec2_stop":
        ec2.stop_instances(InstanceIds=[instance_id])            

    elif schedule_action == "ec2_start":
        ec2.start_instances(InstanceIds=[instance_id])