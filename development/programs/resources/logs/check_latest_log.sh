#
# This script prints the content of the latest log file.
#
# Version: 0.1
# Author: Marcelo Leite

log_preffix="muni_program";
print_size=80

ls -A1rt ${log_preffix}*.log | tail -n 1 | xargs vi ;
