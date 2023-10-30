current_valuation = 0
current_karma = 0


# last_valuation = current_valuation
# last_karma     = current_karma
# current_valuation = rand(100)
# current_karma     = rand(200000)
#  send_event('valuation', { current: current_valuation, last: last_valuation })
#  send_event('karma', { current: current_karma, last: last_karma })
 

# send_event('feedback-score',   { value: 9.95})

SCHEDULER.every '4s' do
    average_feedback_str = `python3 google_sheets_api_sync/print_sheet_stats.py`.chomp
    average_feedback_float = average_feedback_str.to_f.round(2)
    send_event('feedback-score',   { value: average_feedback_float})
end