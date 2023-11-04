require 'json'

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
  data_dict = read_json_file_to_dict(JSON_FILE_PATH)

  data_dict.each do |key, values|
    send_event(values['Col_B'], { values['Col_D'] => values['Col_C'] })
    sleep(0.2) # i should be just sending a single event per widget with multiple key-value pairs, but this works provided there's a delay. Maybe I could just be sending the whole json file lol.
  end
end