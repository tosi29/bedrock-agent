import boto3
from datetime import datetime, timedelta

import json


def lambda_handler(event, context):
    agent = event['agent']
    actionGroup = event['actionGroup']
    function = event['function']
    parameters = event.get('parameters', [])

    responseBody =  {
        "TEXT": {
            "body": json.dumps(get_aws_cost_by_services(), ensure_ascii=False)

        }
    }

    action_response = {
        'actionGroup': actionGroup,
        'function': function,
        'functionResponse': {
            'responseBody': responseBody
        }
    }

    dummy_function_response = {'response': action_response, 'messageVersion': event['messageVersion']}
    print("Response: {}".format(dummy_function_response))

    return dummy_function_response


def get_aws_cost_by_services():
    # Cost Explorer クライアントを作成
    ce = boto3.client('ce')

    # 日付範囲を設定（例：先月の1日から最終日まで）
    end_date = datetime.now().replace(day=1) - timedelta(days=1)
    start_date = end_date.replace(day=1)

    # Cost Explorer API を呼び出し
    response = ce.get_cost_and_usage(
        TimePeriod={
            'Start': start_date.strftime('%Y-%m-%d'),
            'End': end_date.strftime('%Y-%m-%d')
        },
        Granularity='MONTHLY',
        Metrics=['UnblendedCost'],
        GroupBy=[
            {'Type': 'DIMENSION', 'Key': 'SERVICE'}
        ]
    )

    # 結果を処理
    results = []
    for group in response['ResultsByTime'][0]['Groups']:
        service_name = group['Keys'][0]
        amount = float(group['Metrics']['UnblendedCost']['Amount'])
        unit = group['Metrics']['UnblendedCost']['Unit']

        results.append({
            'Service': service_name,
            'Cost': f"{amount:.2f} {unit}"
        })

    # コストの降順でソート
    results.sort(key=lambda x: float(x['Cost'].split()[0]), reverse=True)

    return results