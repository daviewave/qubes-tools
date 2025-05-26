#!/bin/bash
export http_proxy=http://127.0.0.1:8082
export https_proxy=http://127.0.0.1:8082

export qbp=/opt/qubes-builderv2 		# qbp=qubes builder path
export qbpht=${qbp}/helper-tools                # qbpht=setup tools helper tools
export st=/opt/t-setup-tools                   	# st=setup tools
export stht=${st}/helper-tools                  # stht=setup tools helper tools

export qmsk_fp=/usr/share/qubes/qubes-master-key.asc
export qmsk_id=427F11FD0FAA4B080123F01CDDFA1A3E36879494
export qrsk=720415900AB8C804
export qdsk=ED65462EC8D5E4C5

export archive_keyring=/usr/share/keyrings
export srcs_lists=/etc/apt/sources.list.d
export trusted_gpgs=/etc/apt/trusted.gpgs.d
