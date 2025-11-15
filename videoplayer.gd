extends Node


# suggestion : when uploading video to bucket always store the video url in the table
#			   when app launch fetch table value then place the value as a match case
#			   
#			   (uploading panel)
#			   match case, how do we even add a match case to an existing match case ?
				
				
@onready var http = HTTPRequest.new()
var temp_path = "user://temp_video.webm"
var local = "pasig"

func _ready():
	add_child(http)
	http.request_completed.connect(Callable(self, "_on_request_completed"))
	
	match local:
		"pasig":http.request("https://lwiklljhrmjxxiggofyd.supabase.co/storage/v1/object/public/videos/Pasig.webm")
		"ahyst1":http.request("https://lwiklljhrmjxxiggofyd.supabase.co/storage/v1/object/public/videos/sample_3840x2160.webm")
		
func _on_request_completed(result: int, code: int, headers: Array, body: PackedByteArray):
	if code != 200:
		print("Failed to fetch video:", code)
		return
	FileAccess.open(temp_path, FileAccess.WRITE).store_buffer(body)
	$VideoStreamPlayer.stream = load(temp_path)
	$VideoStreamPlayer.expand = true
	$VideoStreamPlayer.play()
