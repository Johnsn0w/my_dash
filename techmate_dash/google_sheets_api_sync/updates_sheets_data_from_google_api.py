#!/usr/bin/env python3

from __future__ import print_function

import os.path
import json
import pandas as pd

from google.auth.transport.requests import Request
from google.oauth2.credentials import Credentials
from google_auth_oauthlib.flow import InstalledAppFlow
from googleapiclient.discovery import build
from googleapiclient.errors import HttpError


# If modifying these scopes, delete the file token.json../
SCOPES = ['https://www.googleapis.com/auth/spreadsheets.readonly']
SAMPLE_SPREADSHEET_ID = '1vxNCq73TBin1FY4BqgYNjVG8EQ3XpIta5b3xSKSf_nI'  # sheet shared from techmate account, "TESTING VERSION2 - SIGNIN DATA"
SAMPLE_RANGE_NAME = 'Smashing_sync_data!sync_data'


SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
TOKEN_PATH = os.path.join(SCRIPT_DIR, 'token.json')
CREDENTIALS_PATH = os.path.join(SCRIPT_DIR, 'credentials.json')
JSON_FILE_PATH = os.path.join(SCRIPT_DIR, './sheets_data.json')
assert os.path.exists(CREDENTIALS_PATH), f"Error: {CREDENTIALS_PATH} file not found. You should generate this via google cloud console"

def write_dict_to_json_file(data_dict, JSON_FILE_PATH):
    try:
        with open(JSON_FILE_PATH, 'w') as json_file:
            json.dump(data_dict, json_file, indent=4, ensure_ascii=False)
    except Exception as e:
        print(f"Error writing to JSON file: {e}")

# TOKEN_PATH = './token.json'

def main():
    creds = None
    # The file token.json stores the user's access and refresh tokens, and is
    # created automatically when the authorization flow completes for the first
    # time.
    if os.path.exists(TOKEN_PATH):
        creds = Credentials.from_authorized_user_file(TOKEN_PATH, SCOPES)
    # If there are no (valid) credentials available, let the user log in.
    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            flow = InstalledAppFlow.from_client_secrets_file(
                CREDENTIALS_PATH, SCOPES)
            creds = flow.run_local_server(port=0)
        # Save the credentials for the next run
        with open(TOKEN_PATH, 'w') as token:
            token.write(creds.to_json())

    try:
        service = build('sheets', 'v4', credentials=creds)

        # Call the Sheets API
        sheet = service.spreadsheets()
        result = sheet.values().get(spreadsheetId=SAMPLE_SPREADSHEET_ID,
                                    range=SAMPLE_RANGE_NAME).execute()
        values = result.get('values', [])

        if not values:
            print('No data found.')
            return

        # Convert the data to a DataFrame
        df = pd.DataFrame(values, columns=["Col_A", "Col_B", "Col_C", "Col_D"])

        # Create a dictionary from the DataFrame
        data_dict = df.set_index('Col_A')[['Col_B', 'Col_C', "Col_D"]].to_dict(orient='index')

        write_dict_to_json_file(data_dict, JSON_FILE_PATH)


    except HttpError as err:
        print(err)
    except ValueError as e:
        print(f"Error converting value to float: {e}")
def return_cell_data():
    pass


if __name__ == '__main__':
    main()