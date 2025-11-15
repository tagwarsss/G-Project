extends Node

const SUPABASE_URL := "https://lwiklljhrmjxxiggofyd.supabase.co/rest/v1/user_quizzes?select=id&limit=1"
const SUPABASE_KEY := "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imx3aWtsbGpocm1qeHhpZ2dvZnlkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTI3MzgyNjUsImV4cCI6MjA2ODMxNDI2NX0.OkhG_c_WD5xHCF7QCHTa8ivr2AvjQhAb2LFOlVrqcS4"

var poll_timer := Timer.new()
var request_timeout := Timer.new()
var request_in_progress := false

var http := HTTPRequest.new() # reused

var temp := "online"

func _ready() -> void:
	await get_tree().process_frame

	add_child(http)
	http.request_completed.connect(_on_request_completed)

	# polling timer
	poll_timer.wait_time = 5.0
	poll_timer.one_shot = false
	poll_timer.autostart = true
	poll_timer.timeout.connect(select_first_row)
	add_child(poll_timer)

	# request timeout
	request_timeout.one_shot = true
	request_timeout.wait_time = 1.0
	request_timeout.timeout.connect(_on_request_timeout)
	add_child(request_timeout)

	select_first_row()


func select_first_row() -> void:
	if request_in_progress:
		return

	var headers := [
		"apikey: " + SUPABASE_KEY,
		"Authorization: Bearer " + SUPABASE_KEY
	]

	var err := http.request(SUPABASE_URL, headers)
	if err != OK:
		print("❌ request start error:", err)
		if temp != "offline":
			_show_offline_behavior()
		
		
	else:
		print("🌐 request started successfully")
		request_in_progress = true
		request_timeout.start()


func _on_request_completed(result, response_code, _headers, _body) -> void:
	request_in_progress = false
	request_timeout.stop()

	if result != OK or response_code != 200:
		print("⚠️ server offline or unreachable")
		if temp != "offline":
			_show_offline_behavior()
	else:
		print("✅ server online, status 200")
		if temp != "online":
			_show_online_behavior()


func _on_request_timeout() -> void:
	if request_in_progress:
		request_in_progress = false
		print("⏱ request timed out")
		if temp != "offline":
			_show_offline_behavior()



func _show_offline_behavior() -> void:
	overlay.show_overlay()
	temp = "offline"

func _show_online_behavior() -> void:
	overlay.hide_overlay()
	temp = "online"
	
