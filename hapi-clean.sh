#!/bin/bash
## Testing awk

function hapiClean {
	echo 'Killing all hapi gulp processes...'
	output=$(ps a | grep gulp | awk '{print $1}') 2>&1

	for process in ${output}
	do
		kill -9 ${process}
	done
	echo 'Done'
}