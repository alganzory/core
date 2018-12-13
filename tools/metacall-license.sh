#!/bin/bash

#
#	MetaCall License Bash Script by Parra Studios
#	Copyright (C) 2016 - 2019 Vicente Eduardo Ferrer Garcia <vic798@gmail.com>
#
#	License bash script utility for MetaCall.
#

# Warning
echo "WARNING: Do not run the script multiple times. Uncomment the 'exit 0' in the code to continue."
exit 0

# Execution path
EXEC_PATH="`pwd`"

# Replacement
find "$EXEC_PATH" -type f \
	-not -path "*/build*" \
	-not -path "*/source/tests/googletest*" \
	-not -name "LICENSE" \
	-not -name "COPYRIGHT" \
	-exec sh -c ' \

	# Copyright
	COPYRIGHT="Copyright (C) 2016 - 2019 Vicente Eduardo Ferrer Garcia <vic798@gmail.com>$"

	# License
	LICENSE=$(cat <<-END

		\tLicensed under the Apache License, Version 2.0 (the "License");
		\tyou may not use this file except in compliance with the License.
		\tYou may obtain a copy of the License at

		\t\thttp://www.apache.org/licenses/LICENSE-2.0

		\tUnless required by applicable law or agreed to in writing, software
		\tdistributed under the License is distributed on an "AS IS" BASIS,
		\tWITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
		\tSee the License for the specific language governing permissions and
		\tlimitations under the License.
	END
	)

	comment=$(grep "$COPYRIGHT" {})

	if [ ! -z "$comment" ]
	then
		file=$(grep -lrnw {} -e "$COPYRIGHT")
		linenum=$(grep -n {} -e "$COPYRIGHT" | cut -d : -f 1)

		# Select between comment type
		expr match "$comment" "\#*" >/dev/null
		# expr match "$comment" " \**" >/dev/null

		if [ $? -eq 0 ]
		then
			# Swap description and copyright from the header
			printf %s\\n $(($linenum + 2))m$(($linenum - 1)) w q | ed -s $file
			printf %s\\n $(($linenum + 1))m$(($linenum + 2)) w q | ed -s $file

			lineliteral="i"

			# Apply prefix depending on comment type
			license=$(echo "$LICENSE" | sed "s/^/#/g")
			# license=$(echo "$LICENSE" | sed "s/^/ \*/g")

			expression="$(($linenum + 3))$lineliteral|$license"

			# Write license
			# TODO: Review $linenum expansion error, remove the pipe to null when solved
			ex -s -c "$expression" -c x "$file" &> /dev/null
		fi
	fi
' \;
