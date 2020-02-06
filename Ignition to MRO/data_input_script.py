-# Script for Retrieve Data from Ignition to MRO Server
# 11/20/19

# For model KW_CM1_GB

# Case sensitive 
tag_path = [
    "be-mill_out_amp",
    "mill drive_power",
    "mill_ch1_water spray",
    "mill_in_pres",
    "mill_out_pres",
    "mill_out_temp",
    "be-rp_in_amp",
    "feed gate1_open",
    "feed gate2_open",
    "rp drive-m1_amp",
    "rp drive-m2_amp",
    "slide gate_drive_open",
    "slide gate_nondrive_open",
    "sep fan_damper",
    "sep fan_power",
    "sep_motor_amp",
    "sep_motor_speed",
    "hopper_cli_lev",
    "tot_feed"
]

cement_no = 1
args = []
query = "INSERT INTO ML_DATA (t_stamp, tag_value, tag_name) "

for i, tag_name in enumerate(tag_path):
    
    query = query + "(SYSDATETIME(), ?, ?)"
    args.append(system.tag.read("[KW_TAG]CM{}/Cement Mill/{}".format(cement_no, tag_path).value))
    args.append("KW_CM{}_{}".format(cement_no, tag_name))
    
    # Last Iteration
    if len(tag_path)-1 != i:
        query = query + ", "
    else:
        continue

db_connection = ""
# system.db.runPrepUpdate(query, args, db_connection)