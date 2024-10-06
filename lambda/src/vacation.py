import datetime
import json

def lambda_handler(event, context):
    agent = event['agent']
    actionGroup = event['actionGroup']
    function = event['function']
    parameters = event.get('parameters', [])

    print("function", function)
    print("parameters", parameters)

    match function:
        case "get_available_vacations_days":
            employee_id = parameters[0]['value']
            print(f"get_available_vacations_daysが呼ばれました：{employee_id}")
            response_text = f"{employee_id}が残り取得可能な日数は8日です。"
        case "reserve_vacation_time":
            for item in parameters:
                if item['name'] == 'start_date':
                    start_date = item['value']
                elif item['name'] == 'end_date':
                    end_date = item['value']
                elif item['name'] == 'employee_id':
                    employee_id = item['value']
            print(f"{employee_id}：{start_date}〜{end_date}で休暇を取得します")
            response_text = f"{employee_id}：{start_date}〜{end_date}で休暇を予約しました"

    # Execute your business logic here. For more information, refer to: https://docs.aws.amazon.com/bedrock/latest/userguide/agents-lambda.html
    responseBody =  {
        "TEXT": {
            "body": response_text
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
