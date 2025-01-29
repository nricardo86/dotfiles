import subprocess
# Define the command to run in the background
command = ['python3', '/home/admin/nhs/nhs.py']
# Run the command in the background
subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
