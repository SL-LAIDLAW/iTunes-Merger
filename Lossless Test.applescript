#!/usr/bin/env osascript

tell application "iTunes"
	repeat with myTrack in selection
		set mybitrate to bit rate of myTrack
		if mybitrate is greater than 361 then
			-- Set file
			set mytrack_name to (name of myTrack)
			set mytrack_file to (location of myTrack)
			
			-- convert the alac to wav
			set mytrack_posix to (POSIX path of mytrack_file)
			set track_convert to do shell script "/usr/local/bin/ffmpeg -y -loglevel panic -i '" & mytrack_posix & "' '" & mytrack_posix & ".wav'"
			
			-- test the wav for lossless-ness
			set track_test to do shell script "/usr/local/bin/lac '" & mytrack_posix & ".wav' | grep 'Result: Clean'"
			if (track_test as string) is equal to "Result: Clean" then
				log (mytrack_name as string) & " : Clean"
			else
				try
					duplicate myTrack to user playlist "Not-Lossless"
				on error
					make new user playlist with properties {name:"Not-Lossless"}
					duplicate myTrack to user playlist "Not-Lossless"
				end try
			end if
			
			do shell script "rm '" & mytrack_posix & ".wav'"
		end if
	end repeat
end tell