extends Object
class_name FileManage

const SAVE_DIR := "user://saves/"
const PLAYER_DATA_FILE_NAME := "pd.json"
const SKILL_DATA_FILE_NAME  := "sk.json"

const SECURITY_KEY := "S1C5S145GNSSV45"

var path :String

func _init() -> void:
	verify_save_directoty(SAVE_DIR)

#验证目录是否合法
func verify_save_directoty(_path:String) -> void:
	DirAccess.make_dir_absolute(_path)
	
func load_data(_which:int) -> Dictionary:
	var _path :String = _get_file_name(_which)
	
	if not FileAccess.file_exists(_path):
		printerr("无法找到并打开该文件 %s" % [_path] )
		return {"state":false,"msg":"无法找到并打开该文件 %s" % [_path]}
		
	var file = FileAccess.open_encrypted_with_pass(_path,FileAccess.READ,SECURITY_KEY)
	if not file:
		print(FileAccess.get_open_error())
		return {"state":false,"msg":FileAccess.get_open_error()}
	
	var content := file.get_as_text()
	file.close()
	
	var data := JSON.parse_string(content)
	if not data:
		printerr("Cannot parse %s as a json_string %s" % [_path,content] )
		return {"state":false,"msg":"Cannot parse %s as a json_string %s" % [_path,content]}
	
	return {"state":true,"data":data}
	
func save_data(_data:Dictionary,_which:int) -> Dictionary:
	var _path :String = _get_file_name(_which)
	
	var file = FileAccess.open_encrypted_with_pass(_path,FileAccess.WRITE,SECURITY_KEY)
	if not file:
		print(FileAccess.get_open_error())
		return {"state":false,"msg":FileAccess.get_open_error()}
	
	var json_string := JSON.stringify(_data,"\t")
	
	file.store_string(json_string)
	file.close()
	
	return {"state":true}
	
func _get_file_name(_which:int) -> String :
	match _which:
		0:
			return SAVE_DIR + PLAYER_DATA_FILE_NAME
		1:
			return SAVE_DIR + SKILL_DATA_FILE_NAME
	return ""
