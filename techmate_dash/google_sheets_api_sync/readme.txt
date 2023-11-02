google quickstart for Sheets API
creted using guide
    https://developers.google.com/sheets/api/quickstart/python


updates_sheets_data_from_google_api.py
    runs oauth if not previously authenticated
    pulls named range from google sheet to json dictionary

assign_values.rb
    routinely calls updates_sheets_data_from_google_api.py to update json
    reads the json into a dict, 
    parses the key value pairs be sent as send_event to update the dashboard assign_values
    