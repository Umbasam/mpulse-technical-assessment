import os
import boto3

ec2 = boto3.client('ec2')

# Uses the env vars to determine if this function should Stop or Start the instance

def lambda_handler(event, context):
    scheduler_action = os.environ['SCHEDULER_ACTION']
    instance_id = os.environ['INSTANCE_ID']

    env_vars_output = f"Env Vars: scheduler_action = {scheduler_action}, instance_id = {instance_id}"
    print(env_vars_output)

    if scheduler_action == "ec2_stop":
        response = ec2.stop_instances(InstanceIds=[instance_id])
        print(response)     

    elif scheduler_action == "ec2_start":
        response = ec2.start_instances(InstanceIds=[instance_id])
        print(response)

    else:
        print("the 'scheduler_action' var does not match 'ec2_stop' or 'ec2_start'")