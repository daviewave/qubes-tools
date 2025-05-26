#!/bin/bash
export http_proxy=http://127.0.0.1:8082
export https_proxy=http://127.0.0.1:8082

export qbp=/opt/qubes-builderv2 		# qbp=qubes builder path
export qbpht=${qbp}/helper-tools                # qbpht=setup tools helper tools
export st=/opt/t-setup-tools                   	# st=setup tools
export stht=${st}/helper-tools                  # stht=setup tools helper tools
export archive_keyring=/usr/share/keyrings

export q_master_key_id=427F11FD0FAA4B080123F01CDDFA1A3E36879494
#export 
