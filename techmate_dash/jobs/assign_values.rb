require 'json'
# send_event('feedback-score',   { value: 9.95})
JSON_FILE_PATH = '/workspaces/my_dash/techmate_dash/google_sheets_api_sync/sheets_data.json'

def read_json_file_to_dict(file_path)
    data = {}  # Initialize data as an empty dictionary
    begin
      File.open(file_path) do |f|
        data = JSON.parse(f.read)
      end
    rescue StandardError => e
      puts "Error reading from JSON file: #{e}"
    end
    data  # Return data whether or not an error occurred
  end

SCHEDULER.every '4s' do
  _ = `python /workspaces/my_dash/techmate_dash/google_sheets_api_sync/updates_sheets_data_from_google_api.py`
    # Read data from JSON file
  data_dict = read_json_file_to_dict(JSON_FILE_PATH)

  # Send each key-value pair as an event
  # GAH, so i've rougly patched it here because the send_event parameter should change the value it's sending based on the event_name
  data_dict.each do |event_name, event_data|
    if event_name == "record-count"
      send_event(event_name, { text: event_data })
    elsif event_name == "feedback-score"
      send_event(event_name, { value: event_data })
    end
  end
end